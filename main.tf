#---------------------
# Apache Webserver
# green-blue deployment
#---------------------

provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = var.tags
}

data "aws_availability_zones" "aws_az" {
  state = "available"
}

data "aws_ami" "the_latest_amazon_linux" {
  owners      = var.ami_owners
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_type_filter]
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.aws_az.names[0]

  tags = {
    Name = "Default subnet for ${data.aws_availability_zones.aws_az.names[0]}"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.aws_az.names[1]

  tags = {
    Name = "Default subnet for ${data.aws_availability_zones.aws_az.names[1]}"
  }
}

resource "aws_security_group" "security_group" {
  name = var.aws_security_group_name

  tags = {
    Owner = var.owner
  }

  dynamic "ingress" {
    for_each = [var.ingress_port_number]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.ingress_cidr_blocks]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.32.0/20"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "webserver" {
  name_prefix     = "WebServer-"
  image_id        = data.aws_ami.the_latest_amazon_linux.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.security_group.id]
  user_data       = templatefile("script.sh.tpl", {})

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "elb" {
  name               = "webserver-demo"
  availability_zones = [data.aws_availability_zones.aws_az.names[0], data.aws_availability_zones.aws_az.names[1]]
  security_groups    = [aws_security_group.security_group.id]
  listener {
    instance_port     = var.aws_elb_listener_instance_port
    instance_protocol = var.aws_elb_listener_instance_protocol
    lb_port           = var.aws_elb_listener_lb_port
    lb_protocol       = var.aws_elb_listener_lb_protocol
  }
  health_check {
    healthy_threshold   = var.aws_elb_health_check_healthy_threshold
    unhealthy_threshold = var.aws_elb_health_check_unhealthy_threshold
    timeout             = var.aws_elb_health_check_timeout
    target              = var.aws_elb_health_check_target
    interval            = var.aws_elb_health_check_interval
  }
  tags = {
    Name = "webserver-elb"
  }
}

resource "aws_autoscaling_group" "autoscaling" {
  name                      = "autoscaling_group-${aws_launch_configuration.webserver.name}"
  max_size                  = var.aws_autoscaling_group_max_size
  min_size                  = var.aws_autoscaling_group_min_size
  health_check_grace_period = var.aws_autoscaling_group_health_check_grace_period
  health_check_type         = var.aws_autoscaling_group_health_check_type
  desired_capacity          = var.aws_autoscaling_group_desired_capacity
  load_balancers            = [aws_elb.elb.name]
  launch_configuration      = aws_launch_configuration.webserver.name
  vpc_zone_identifier       = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]

  dynamic "tag" {
    for_each = {
      Name  = var.stage
      Owner = var.owner
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    delete = var.aws_autoscaling_group_timeouts
  }
}

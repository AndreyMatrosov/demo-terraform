stage = "dev"

region = "us-east-2"

cidr_block = "192.168.0.0/28"

tags = {
  Name = "demoVPC"
}

ami_owners = ["amazon"]

ami_type_filter = "amzn2-ami-hvm-*-x86_64-gp2"

aws_security_group_name = "dynamic_security_group"

ingress_port_number = "80"
ingress_cidr_blocks = "0.0.0.0/0"

instance_type = "t2.micro"

aws_elb_listener_instance_port     = 80
aws_elb_listener_instance_protocol = "http"
aws_elb_listener_lb_port           = 80
aws_elb_listener_lb_protocol       = "http"

aws_elb_health_check_healthy_threshold   = 2
aws_elb_health_check_unhealthy_threshold = 2
aws_elb_health_check_timeout             = 3
aws_elb_health_check_target              = "HTTP:80/"
aws_elb_health_check_interval            = 10

aws_autoscaling_group_max_size                  = 3
aws_autoscaling_group_min_size                  = 1
aws_autoscaling_group_health_check_grace_period = 300
aws_autoscaling_group_health_check_type         = "ELB" # Readiness probe
aws_autoscaling_group_desired_capacity          = 2

autoscaling_group_name = "web-"
owner                  = "andrei_matrosau"

aws_autoscaling_group_timeouts = "10m"

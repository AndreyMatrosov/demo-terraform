variable "stage" {
  type = string
}

variable "region" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "ami_owners" {
  type = list(any)
}

variable "ami_type_filter" {
  type = string
}

variable "aws_security_group_name" {
  type = string
}

variable "ingress_port_number" {
  type = string
}

variable "ingress_cidr_blocks" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "aws_elb_listener_instance_port" {
  default = "type = string"
}

variable "aws_elb_listener_instance_protocol" {
  type = string
}

variable "aws_elb_listener_lb_port" {
  type = string
}

variable "aws_elb_listener_lb_protocol" {
  type = string
}

variable "aws_elb_health_check_healthy_threshold" {
  type = string
}

variable "aws_elb_health_check_unhealthy_threshold" {
  type = string
}

variable "aws_elb_health_check_timeout" {
  type = string
}

variable "aws_elb_health_check_target" {
  type = string
}

variable "aws_elb_health_check_interval" {
  type = string
}

variable "aws_autoscaling_group_max_size" {
  type = string
}

variable "aws_autoscaling_group_min_size" {
  type = string
}

variable "aws_autoscaling_group_health_check_grace_period" {
  type = string
}

variable "aws_autoscaling_group_health_check_type" {
  type = string
}

variable "aws_autoscaling_group_desired_capacity" {
  type = string
}

variable "autoscaling_group_name" {
  type = string
}

variable "owner" {
  type = string
}

variable "aws_autoscaling_group_timeouts" {
  type = string
}

output "web_lb_url" {
  value = aws_elb.elb.dns_name
}

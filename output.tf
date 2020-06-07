output "dns_name" {
  description = "DNS of ALB"
  value = aws_lb.alb.dns_name
}

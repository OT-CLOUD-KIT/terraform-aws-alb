output "dns_name" {
  description = "DNS of ALB"
  value = aws_lb.alb.dns_name
}

output "aws_lb_arn" {
  description = "ARN of alb"
  value = aws_lb.alb.arn
}

output "alb_listener_arn" {
  description = "ARN of alb listener"
  value = aws_alb_listener.alb_listener.arn
}

output "alb_listener1_arn" {
  description = "ARN of alb listener-1"
  value = aws_alb_listener.alb_listener1.arn
}
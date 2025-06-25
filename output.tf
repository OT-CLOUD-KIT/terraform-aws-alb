output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "target_group_arns" {
  value = [for tg in aws_lb_target_group.tg : tg.arn]
}

output "alb_listener_ports" {
  value = concat(
    [for l in aws_lb_listener.listener_http : l.port],
    [for l in aws_lb_listener.listener_https : l.port]
  )
}

output "alb_security_group_id" {
  value = var.create_sg ? aws_security_group.alb_sg[0].id : var.existing_sg_id
}

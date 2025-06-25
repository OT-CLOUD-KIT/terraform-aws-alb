output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "DNS name of the ALB"
}

output "alb_arn" {
  value       = module.alb.alb_arn
  description = "ARN of the ALB"
}

output "target_group_arns" {
  value       = module.alb.target_group_arns
  description = "Target group ARNs"
}

output "alb_security_group_id" {
  value       = module.alb.alb_security_group_id
  description = "Security group ID used by the ALB"
}

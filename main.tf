resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_groups_id
  subnets            = var.subnets_id
  enable_deletion_protection = var.enable_deletion_protection 

  tags = merge(
    {
      "Name" = format("%s", var.alb_name)
    },
    var.tags,
  )



   access_logs{
    bucket        = var.enable_logging == true ? var.logs_bucket : null
    prefix = var.enable_logging == true ? format("%s-alb", var.alb_name) : null
    enabled      = var.enable_logging
  }
}

resource "aws_alb_listener" "alb_http_listener" { 
  load_balancer_arn = aws_lb.alb.arn  
  port              = 80  
  protocol          = "HTTP"
  
    default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "alb_https_listener" { 
  load_balancer_arn = aws_lb.alb.arn  
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.alb_certificate_arn != "" ? var.alb_certificate_arn : null

 default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  } 
}

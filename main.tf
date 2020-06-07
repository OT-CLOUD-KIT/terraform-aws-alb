resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_groups_id
  subnets            = var.subnets_id
  enable_deletion_protection = var.enable_deletion_protection 

  tags = merge(
    {
      "Name" = format("%s-alb", var.alb_name)
    },
    var.tags,
  )

  access_logs {
    bucket        = var.logs_bucket
    prefix = format("%s-alb", var.alb_name)
    enabled      = var.enable_logging
  }
}

resource "aws_alb_listener" "alb_listener" { 
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

resource "aws_alb_listener" "alb_listener1" { 
  load_balancer_arn = aws_lb.alb.arn  
  port              = 443
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

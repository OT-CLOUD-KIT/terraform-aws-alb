resource "aws_security_group" "alb_sg" {
  count       = var.create_sg ? 1 : 0
  name        = "${local.base_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.listeners
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidrs
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${local.base_name}-alb-sg"
    },
    local.common_tags
  )
}

resource "aws_lb" "alb" {
  name                        = "${local.base_name}-alb"
  internal                    = var.internal
  load_balancer_type          = "application"
  subnets                     = var.subnet_ids
  security_groups             = [var.create_sg ? aws_security_group.alb_sg[0].id : var.existing_sg_id]
  enable_deletion_protection = var.enable_deletion_protection

  dynamic "access_logs" {
    for_each = var.access_logs.enabled && var.access_logs.bucket != null && var.access_logs.prefix != null ? [1] : []
    content {
      bucket  = var.access_logs.bucket
      prefix  = var.access_logs.prefix
      enabled = true
    }
  }

  tags = merge(
    {
      Name = "${local.base_name}-alb"
    },
    local.common_tags
  )
}

resource "aws_lb_target_group" "tg" {
  for_each = { for l in var.listeners : tostring(l.port) => l }

  name     = "${local.base_name}-tg-${each.key}"
  port     = each.value.target_port
  protocol = each.value.target_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = lookup(each.value, "health_path", "/")
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = merge(
    {
      Name = "${local.base_name}-tg-${each.key}"
    },
    local.common_tags
  )
}

resource "aws_lb_listener" "listener_http" {
  for_each = { for l in var.listeners : tostring(l.port) => l if l.protocol == "HTTP" }

  load_balancer_arn = aws_lb.alb.arn
  port              = each.value.port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[each.key].arn
  }

  tags = merge(
    {
      Name = "${local.base_name}-listener-http-${each.key}"
    },
    local.common_tags
  )
}

resource "aws_lb_listener" "listener_https" {
  for_each = { for l in var.listeners : tostring(l.port) => l if l.protocol == "HTTPS" }

  load_balancer_arn = aws_lb.alb.arn
  port              = each.value.port
  protocol          = "HTTPS"
  certificate_arn   = each.value.certificate_arn
  ssl_policy        = lookup(each.value, "ssl_policy", "ELBSecurityPolicy-TLS-1-2-2017-01")

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[each.key].arn
  }

  tags = merge(
    {
      Name = "${local.base_name}-listener-https-${each.key}"
    },
    local.common_tags
  )
}

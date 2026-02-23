
locals {
  security_group_id = length(aws_security_group.this) > 0 ? [aws_security_group.this[0].id] : var.sgp_ids
}

# resource "aws_lb_target_group_attachment" "this" {
#   target_group_arn = aws_lb_target_group.this.arn
#   target_id        = ""
#   port             = 443
# }

# resource "aws_lb_target_group" "this" {
#   name             = "tg-${var.name}${var.suffix}"
#   protocol         = "HTTPS"
#   protocol_version = "HTTP1"
#   port             = 80
#   vpc_id           = data.aws_vpc.this.id
#   health_check {
#     enabled             = true
#     protocol            = "HTTPS"
#     path                = "/"
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#     timeout             = 5
#     interval            = 30
#   }
#   tags = {
#     Name = "tg-${var.name}${var.suffix}"
#   }
# }

# resource "aws_lb_listener" "this" {
#   load_balancer_arn = aws_lb.this.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
#   # certificate_arn   = aws_acm_certificate.acm-alb.arn
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.this.arn
#   }
#   tags = {
#     Name = "listener-${var.name}${var.suffix}"
#   }
# }

# resource "aws_alb_listener_certificate" "this" {
#   listener_arn    = aws_lb_listener.this.arn
#   certificate_arn = var.certificate_arn
# }

resource "aws_lb" "this" {
  name                       = "alb-${var.name}${var.suffix}"
  internal                   = true
  ip_address_type            = "ipv4"
  security_groups            = local.security_group_id
  subnets                    = [for subnet_id in data.aws_subnets.this.ids : subnet_id]
  drop_invalid_header_fields = true

  tags = {
    Name = "alb-${var.name}${var.suffix}"
  }
}

resource "aws_security_group" "this" {
  count       = length(var.ports) > 0 ? 1 : 0
  vpc_id      = data.aws_vpc.this.id
  name        = "sgp-${var.name}${var.suffix}"
  description = "SGP exclusive to alb-${var.name}${var.suffix}"
  dynamic "ingress" {
    for_each = var.ports
    content {
      description = "ingress-rule-number-${ingress.key}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.cidr_zero]
    }
  }
  egress {
    description = "all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_zero]
  }

  tags = {
    Name = "sgp-${var.name}${var.suffix}"
  }

  lifecycle {
    precondition {
      condition     = length(var.sgp_ids) == 0
      error_message = "Bad call to module | Only is required either var.ports or var.sgp_id, not both"
    }
    create_before_destroy = true
  }
}

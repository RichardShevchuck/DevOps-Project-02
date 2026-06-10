resource "aws_alb" "app_alb" {
  name            = "app-alb"
  internal        = false
  security_groups = [var.alb_security_group_id]
  subnets         = [var.public_subnet_id0, var.public_subnet_id1]

  tags = {
    Name        = "app-alb"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
  }

  tags = {
    Name        = "app-tg"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

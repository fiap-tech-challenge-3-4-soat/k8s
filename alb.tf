resource "aws_alb" "sistema-pedidos_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sistema-pedidos_security_group.id]
  subnets            = [aws_subnet.sistema-pedidos_subnet_a.id, aws_subnet.sistema-pedidos_subnet_b.id]

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# Create a default target group
resource "aws_alb_target_group" "sistema-pedidos_default_target_group" {
  name                 = "default-target-group"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = aws_vpc.sistema-pedidos_vpc.id
  target_type          = "ip"

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
  depends_on = [aws_alb.sistema-pedidos_alb]
}

# Create a listener for the ALB
resource "aws_alb_listener" "sistema-pedidos_alb_listener" {
  load_balancer_arn = aws_alb.sistema-pedidos_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.sistema-pedidos_default_target_group.arn
  }

  depends_on = [aws_alb_target_group.sistema-pedidos_default_target_group]
}
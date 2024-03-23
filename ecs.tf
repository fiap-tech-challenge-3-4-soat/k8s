resource "aws_ecs_cluster" "sistema-pedidos_ecs" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "sistema-pedidos_task_definition" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"  # CPU units (1 vCPU = 1024 CPU units)
  memory                   = "512"  # Memory in MiB

  container_definitions    = jsonencode([
    {
      name                  = "${var.project_name}-container"
      image                 = "hello-world:latest"
      cpu                   = 1    # CPU units for container (optional, overrides task level CPU)
      memory                = 512    # Memory in MiB for container (optional, overrides task level memory)
      portMappings          = [
        {
          containerPort     = 80    # Container port
          protocol          = "tcp" # Protocol
        }
      ]
    }
  ])

  depends_on = [aws_alb_listener.sistema-pedidos_alb_listener]
}

resource "aws_ecs_service" "sistema-pedidos_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.sistema-pedidos_ecs.id
  task_definition = aws_ecs_task_definition.sistema-pedidos_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_alb_target_group.sistema-pedidos_default_target_group.arn
    container_name   = "${var.project_name}-container"
    container_port   = "80"
  }

  network_configuration {
    subnets          = [aws_subnet.sistema-pedidos_subnet_a.id, aws_subnet.sistema-pedidos_subnet_b.id] # Subnet ID(s) where the service will be deployed
    security_groups  = [aws_security_group.sistema-pedidos_security_group.id] # Security group ID(s) for the service
    assign_public_ip = false # Whether to assign a public IP to the tasks
  }

  depends_on = [aws_ecs_task_definition.sistema-pedidos_task_definition]
}
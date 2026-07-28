resource "aws_security_group" "ecs" {

  name   = "${var.project_name}-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = var.container_port
    to_port   = var.container_port
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}
resource "aws_security_group" "alb" {

  name   = "${var.project_name}-alb-sg"

  vpc_id = var.vpc_id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}
resource "aws_ecs_cluster" "cluster" {

  name = "${var.project_name}-cluster"

}
resource "aws_iam_role" "ecs_task_execution_role" {

  name = "${var.project_name}-ecs-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "ecs-tasks.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}
resource "aws_iam_role_policy_attachment" "ecs_policy" {

  role = aws_iam_role.ecs_task_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}
resource "aws_lb" "alb" {

  name = "${var.project_name}-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [

    aws_security_group.alb.id

  ]

  subnets = [

    var.public_subnet_1_id,

    var.public_subnet_2_id

  ]

}
resource "aws_lb_target_group" "tg" {

  name = "${var.project_name}-tg"

  port = var.container_port

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {

    path = "/"

    protocol = "HTTP"

  }

}
resource "aws_lb_listener" "listener" {

  load_balancer_arn = aws_lb.alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.tg.arn

  }

}
resource "aws_ecs_task_definition" "task" {

  family = "${var.project_name}-task"

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu = var.cpu

  memory = var.memory

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([

    {

      name = "app"

      image = var.container_image

      essential = true

      portMappings = [

        {

          containerPort = var.container_port

          hostPort = var.container_port

        }

      ]

    }

  ])

}
resource "aws_ecs_service" "service" {

  name = "${var.project_name}-service"

  cluster = aws_ecs_cluster.cluster.id

  task_definition = aws_ecs_task_definition.task.arn

  desired_count = var.desired_count

  launch_type = "FARGATE"

  network_configuration {

    subnets = [

      var.private_subnet_1_id,

      var.private_subnet_2_id

    ]

    security_groups = [

      aws_security_group.ecs.id

    ]

    assign_public_ip = false

  }

  load_balancer {

    target_group_arn = aws_lb_target_group.tg.arn

    container_name = "app"

    container_port = var.container_port

  }

  depends_on = [

    aws_lb_listener.listener

  ]

}

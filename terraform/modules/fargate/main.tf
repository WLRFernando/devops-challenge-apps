resource "aws_ecr_repository" "ecr" {
  name                 = var.app_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "ecrpolicy" {
  repository = aws_ecr_repository.ecr.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 10 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "docker_image" "this" {
 name = format("%v:%v", aws_ecr_repository.ecr.repository_url, formatdate("YYYY-MM-DD'T'hh-mm-ss", timestamp()))

 build { 
    context = var.docker_context_path
 } 
}

resource "docker_registry_image" "this" {
 keep_remotely = true 
 name = resource.docker_image.this.name

}

data "aws_iam_role" "ecs_task_execution_role" { 
  name = "ecsTaskExecutionRole" 
}

resource "aws_ecs_task_definition" "taskdefinition" {
 container_definitions = jsonencode([{
  environment: [
   { name = "API_HOST", value = var.api_host },
   { name = "DB_USER", value = var.db_user},
   { name = "DB_PASSWORD", value = var.db_password},
   { name = "DB_HOST", value = var.db_host},
   { name = "DB_DATABASE", value = var.db_database},
  ],
  essential = true,
  image = resource.docker_registry_image.this.name,
  name = var.app_name,
  portMappings = [{ containerPort = var.container_port }],
 }])
 cpu = 256
 execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
 
 family = "family-of-${var.app_name}-tasks"
 memory = 512
 network_mode = "awsvpc"
 requires_compatibilities = ["FARGATE"]
}

resource "aws_security_group" "app-sg" {
  name_prefix = "app-sg-"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr]
  }
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "app-tg" {
  name        = "${var.app_name}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = var.health_check_path
    interval = 60
    timeout = 59
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = var.listener_arn
  priority     = var.rule_priority

  action {
    type             = "forward"
    target_group_arn = resource.aws_lb_target_group.app-tg.arn
  }

  condition {
    path_pattern {
      values = [var.app_context_path]
    }
  }

}

resource "aws_ecs_service" "ecs-service" {
 cluster = var.cluster_id
 desired_count = 1
 launch_type = "FARGATE"
 name = "${var.app_name}-service"
 task_definition = resource.aws_ecs_task_definition.taskdefinition.arn

 lifecycle {
  ignore_changes = [desired_count] # Allow external changes to happen without Terraform conflicts, particularly around auto-scaling.
 }

 load_balancer {
  container_name = var.app_name
  container_port = var.container_port
  target_group_arn = resource.aws_lb_target_group.app-tg.arn
 }

 network_configuration {
  security_groups = [resource.aws_security_group.app-sg.id]
  subnets = var.public_subnet_id
  assign_public_ip = true
 }
}
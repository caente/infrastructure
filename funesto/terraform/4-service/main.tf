terraform {
  backend "s3" {}
}
provider "aws" {
  region = var.region
}
data "terraform_remote_state" "ecs" {
  backend = "s3"
  config  = {
    region = var.region
    bucket = var.remote_state_bucket
    key    = var.remote_state_key_ecs
  }
}

data "terraform_remote_state" "rds" {
  backend = "s3"
  config  = {
    region = var.region
    bucket = var.remote_state_bucket
    key    = var.remote_state_key_rds
  }
}

data "template_file" "ecs_task_definition_template" {
  template = file("task_definition.json")
  vars     = {
    task_definition_name  = var.ecs_service_name
    ecs_service_name      = var.ecs_service_name
    docker_image_url      = var.docker_image_url
    memory                = var.memory
    docker_container_port = var.docker_container_port
    spring_profile        = var.spring_profile
    region                = var.region
    db_host               = data.terraform_remote_state.rds.outputs.rds_hostname
    db_port               = data.terraform_remote_state.rds.outputs.rds_port
    db_user               = var.db_user
    db_password           = var.db_password
  }
}

resource "aws_ecs_task_definition" "app-definition" {
  container_definitions    = data.template_file.ecs_task_definition_template.rendered
  family                   = var.ecs_service_name
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.fargate_iam_role.arn
  task_role_arn            = aws_iam_role.fargate_iam_role.arn
}

resource "aws_iam_role" "fargate_iam_role" {
  name               = "${var.ecs_service_name}-IAM-Role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect : "Allow"
        Principal : {
          Service = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "fargate_iam_role_policy" {
  name   = "${var.ecs_service_name}-IAM-Role-Policy"
  role   = aws_iam_role.fargate_iam_role.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:*",
          "ecr:*",
          "logs:*",
          "cloudwatch:*",
          "elasticloadbalancing:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_alb_target_group" "ecs_app_target_group" {
  name        = "${var.ecs_service_name}-TG"
  port        = var.docker_container_port
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.ecs.outputs.vpc_id
  target_type = "ip"
  health_check {
    path                = "/api/ping"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = "60"
    timeout             = "30"
    unhealthy_threshold = "3"
    healthy_threshold   = "3"
  }
  tags = {
    Name = "${var.ecs_service_name}-TG"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  task_definition = aws_ecs_task_definition.app-definition.arn
  desired_count   = var.desired_tasks_count
  cluster         = data.terraform_remote_state.ecs.outputs.ecs_cluster_name
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = data.terraform_remote_state.ecs.outputs.public_subnet_ids
    security_groups  = [aws_security_group.app_security_group.id]
    assign_public_ip = true
  }
  load_balancer {
    container_name   = var.ecs_service_name
    container_port   = var.docker_container_port
    target_group_arn = aws_alb_target_group.ecs_app_target_group.arn
  }
}

resource "aws_alb_listener_rule" "ecs_alb_listener_rule" {
  listener_arn = data.terraform_remote_state.ecs.outputs.ecs_alb_listener_arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_app_target_group.arn
  }
  condition {
    host_header {
      values = ["${lower(var.ecs_service_name)}.${data.terraform_remote_state.ecs.outputs.ecs_domain_name}"]
    }
  }
}

resource "aws_cloudwatch_log_group" "app_log_group" {
  name = "${var.ecs_service_name}-LogGroup"
}
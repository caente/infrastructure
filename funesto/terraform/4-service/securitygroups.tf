resource "aws_security_group" "app_security_group" {
  name        = "${var.ecs_service_name}-SG"
  description = "Security Group for ALB to traffic for the app"
  vpc_id      = data.terraform_remote_state.ecs.outputs.vpc_id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.ecs.outputs.vpc_cidr_block]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.ecs_service_name}-SG"
  }
}
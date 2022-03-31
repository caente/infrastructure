resource "aws_security_group" "rds" {
  name        = "RDS-SG"
  description = "Security Group for RDS"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [data.terraform_remote_state.ecs.outputs.alb_security_group_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
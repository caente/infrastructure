resource "aws_security_group" "rds" {
  name        = "RDS-SG"
  description = "Security Group for RDS"
  vpc_id      = data.terraform_remote_state.infrastructure.outputs.vpc_id
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
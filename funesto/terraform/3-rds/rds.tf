provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config  = {
    region = var.region
    bucket = var.remote_state_bucket
    key    = var.remote_state_key
  }
}

resource "aws_db_parameter_group" "mysql" {
  family = "mysql8.0"
  name = "funesto"
}
resource "aws_db_subnet_group" "mysql" {
  name = "mysql_subnet_group"
  subnet_ids = data.terraform_remote_state.infrastructure.outputs.private_subnet_ids
  tags = {
    Name = "Mysql-Subnet-Group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier        = "mysql-db"
  storage_type      = "gp2"
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t2.micro"
  port              = "3306"
  db_subnet_group_name = aws_db_subnet_group.mysql.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name = aws_db_parameter_group.mysql.name
  skip_final_snapshot = true
  password = var.db_password
  username = var.db_user
}
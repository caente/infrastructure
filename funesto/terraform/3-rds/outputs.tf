output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.mysql.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.mysql.port
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

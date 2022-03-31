output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "vpc_cidr_block" {
  value = data.terraform_remote_state.vpc.outputs.vpc_cidr_block
}

output "ecs_alb_listener_arn" {
  value = aws_alb_listener.ecs_alb_https_listener.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.fargate-cluster.name
}

output "ecs_cluster_role_name" {
  value = aws_iam_role.ecs_cluster_role.name
}

output "ecs_cluster_role_arn" {
  value = aws_iam_role.ecs_cluster_role.arn
}

output "ecs_domain_name" {
  value = var.ecs_domain_name
}

output "public_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}

output "private_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}

output "alb_security_group_id" {
  value = aws_security_group.ecs_alb_security_group.id
}
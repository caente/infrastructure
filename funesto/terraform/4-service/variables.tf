variable "profile" {
  description = "AWS profile"
}

variable "region" {
  description = "AWS region"
}

variable "remote_state_bucket" {}

variable "remote_state_key_ecs" {}

variable "remote_state_key_rds" {}

variable "ecs_service_name" {}

variable "docker_image_url" {}

variable "memory" {}

variable "cpu" {}

variable "docker_container_port" {}

variable "desired_tasks_count" {}

variable "spring_profile" {}

variable "db_user" {}

variable "db_password" {}

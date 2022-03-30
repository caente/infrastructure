variable "profile" {
  description = "AWS profile"
}

variable "region" {
  description = "AWS region"
}

variable "vpc_cidr_block" {
  description = "CIDR for the VPC"
}

variable "public_subnets_cidr" {
  description = "Public subnets CIDR"
}

variable "private_subnets_cidr" {
  description = "Private subnets CIDR"
}

variable "availability_zone" {
  description = "Availability zones"
}
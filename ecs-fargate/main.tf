provider "aws" {
  profile = var.profile
  region  = var.region
}

#1. Create VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = var.cidr
}
#2. Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.prod-vpc.id
}
#3. Create Custom Route Table
resource "aws_route_table" "prod-routes" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}
#4. Create Subnets
resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets)
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = element(var.private_subnets, count.index )
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true
}
#5. Associate subnet with Route Table
resource "aws_route_table_association" "subnet-prod" {
  route_table_id = aws_route_table.prod-routes.id
  subnet_id      = element(var.public_subnets, count.index )
  count          = length(var.public_subnets)
}
#6. Create Security Group to allow port 22, 80, 443
resource "aws_security_group" "allow-web" {
  name        = "allow-web"
  description = "Allows web traffic"
  vpc_id      = aws_vpc.prod-vpc.id
  ingress {
    description = "HTTPS"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-web"
  }
}

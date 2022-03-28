provider "aws" {
  profile    = var.profile
  region     = var.region
}

#1. Create VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = {
    Name = "prod-vpc"
  }
}
#2. Create Internet Gateway
resource "aws_internet_gateway" "outside" {
  vpc_id = aws_vpc.prod-vpc.id
  tags   = {
    Name = "outside"
  }
}
#3. Create Custom Route Table
resource "aws_route_table" "prod-routes" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.outside.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.outside.id
  }

  tags = {
    Name = "production"
  }
}
#4. Create Subnets
resource "aws_subnet" "subnet-prod" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.subnet_prefix[0].cidr_block
  availability_zone = var.availability_zone
  tags              = {
    Name = var.subnet_prefix[0].name
  }
}

resource "aws_subnet" "subnet-dev" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.subnet_prefix[1].cidr_block
  availability_zone = var.availability_zone
  tags              = {
    Name = var.subnet_prefix[1].name
  }
}
#5. Associate subnet with Route Table
resource "aws_route_table_association" "subnet-prod" {
  route_table_id = aws_route_table.prod-routes.id
  subnet_id      = aws_subnet.subnet-prod.id
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
#7. Create a network interface with an IP in the subnet that was created in step 4
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-prod.id
  private_ips      = ["10.0.1.50"]
  security_groups = [aws_security_group.allow-web.id]
}
#8. Assign an elastic IP to the network interface created in step 7
resource "aws_eip" "public-address" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = aws_network_interface.web-server-nic.private_ip
  depends_on                = [aws_internet_gateway.outside]
}
#9. Crate Ubuntu server and install/enable apache2

resource "aws_instance" "web-server" {
  ami               = "ami-04505e74c0741db8d"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "main-key"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo server HI! > /var/www/html/index.html'
                EOF
  tags      = {
    Name = "webserver"
  }
}

output "server_public_ip" {
  value = aws_eip.public-address.public_ip
}

output "server_private_ip" {
  value = aws_instance.web-server.private_ip
}
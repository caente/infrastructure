provider "aws" {
  profile = var.profile
  region  = var.region
}

terraform {
  backend "s3" {}
}

resource "aws_vpc" "main-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags                 = {
    Name = "Main-VPC"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = element(var.public_subnets_cidr, count.index )
  availability_zone = element(var.availability_zone, count.index )
  count             = length(var.public_subnets_cidr)
  tags              = {
    Name = "Public-Subnet-${count.index}"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = element(var.private_subnets_cidr, count.index )
  availability_zone = element(var.availability_zone, count.index )
  count             = length(var.private_subnets_cidr)
  tags              = {
    Name = "Private-Subnet-${count.index}"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main-vpc.id
  tags   = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main-vpc.id
  tags   = {
    Name = "Private-Route-Table"
  }
}

resource "aws_route_table_association" "public-route-table-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = element(aws_subnet.public-subnet.*.id,count.index)
  count = length(aws_subnet.public-subnet)
}

resource "aws_route_table_association" "private-route-table-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = element(aws_subnet.private-subnet.*.id,count.index)
  count = length(aws_subnet.private-subnet)
}

resource "aws_eip" "elastic-nat-gateway" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"
  tags                      = {
    Name = "Main-EIP"
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.elastic-nat-gateway.id
  subnet_id     = aws_subnet.public-subnet[0].id
  tags          = {
    Name = "Main-NAT-Gateway"
  }
  depends_on = [aws_eip.elastic-nat-gateway]
}

resource "aws_route" "nat-gateway-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_internet_gateway" "main-internet-gateway" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "Main-Internet-Gateway"
  }
}

resource "aws_route" "public-internet-gateway-route" {
  route_table_id = aws_route_table.public-route-table.id
  gateway_id = aws_internet_gateway.main-internet-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}
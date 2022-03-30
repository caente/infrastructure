output "vpc_id" {
  value = aws_vpc.main-vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main-vpc.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public-subnet.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private-subnet.*.id
}
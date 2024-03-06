
output "vpc_cidr_block" {
  description = "The CIDR block of the selected VPC"
  value       = data.aws_vpc.main-vpc.cidr_block
}

output "ec2_key_name" {
  value = aws_key_pair.ec2_key.key_name
}

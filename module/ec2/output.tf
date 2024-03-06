# The CIDR block of the VPC
output "vpc_cidr_block" {
  description = "The CIDR block of the selected VPC"
  value       = data.aws_vpc.main-vpc.cidr_block
}

# The ec2_key_name
output "ec2_key_name" {
  value = var.key_name
}

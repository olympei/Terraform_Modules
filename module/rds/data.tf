# Data source for azs
data "aws_availability_zones" "available" {
  state = "available"
}
# Data source for vpc
data "aws_vpc" "main-vpc" {
  
  filter {
    name = "tag:Name"
    values = ["main-vpc"]

}
}
# Data source for subnets
data "aws_subnets" "public_subnet" {
  filter {
    name = "tag:Name"
    values = ["public_subnet-*"]
    # values = ["public_subnet-1", "public_subnet-2"]
  }
  
}

# data source for public subnet
data "aws_subnet" "public_subnet-1" {
  
  filter {

name = "tag:Name"

values = ["public_subnet-1"]

}
}

# # data source for private subnet
data "aws_subnet" "private-subnet-ec2" {
  
  filter {

name = "tag:Name"

values = ["private_subnet-1"]

}
}

# data source for vpc
data "aws_vpc" "main-vpc" {
  
  filter {

name = "tag:Name"

values = ["main-vpc"]

}
}

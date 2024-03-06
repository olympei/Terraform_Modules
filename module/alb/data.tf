data "aws_subnets" "public_subnet" {
  filter {
    name = "tag:Name"
    values = ["public_subnet-*"]
  }
  
}

data "aws_vpc" "main-vpc" {
  filter {
    name = "tag:Name"
    values = ["main-vpc"]
  }
  
}

data "aws_instance" "exsiting_ec2" {
  filter {
    name = "tag:Name"
    values = ["demo-ec2_public"]
  }
  
}

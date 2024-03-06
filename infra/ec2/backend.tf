# Store terraform.tfstate in s3 bucket
terraform {
  backend "s3" {
    bucket = "terra-bct"
    key    = "ec2/terraform.tfstate"
    region = "us-east-1"
  }
}

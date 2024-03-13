# store terraform.tfstate file in s3
terraform {
  backend "s3" {
    bucket = "terra-bct"
    key    = "rds/terraform.tfstate"
    region = "us-east-1"
  }
}

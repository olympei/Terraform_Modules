# store terraform.tfstate in s3 bucket
terraform {
  backend "s3" {
    bucket = "terra-bct"
    key    = "s3/terraform.tfstate"
    region = "us-east-1"
  }
}

# Store terraform.tfstate file in s3 bucket
terraform {
  backend "s3" {
    bucket = "terra-bct"
    key    = "acm/terraform.tfstate"
    region = "us-east-1"
  }
}

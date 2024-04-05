# Store terraform.tfstate file in s3 bucket
terraform {
  backend "s3" {
    bucket = "terraform-statefile-s3-bucket"
    key    = "vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

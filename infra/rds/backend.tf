# store terraform.tfstate file in s3
terraform {
  backend "s3" {
    bucket = "terraform-statefile-s3-bucket"
    key    = "rds/terraform.tfstate"
    region = "us-east-2"
  }
}

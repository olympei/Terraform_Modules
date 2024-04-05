# store terraform.tfstate in s3 bucket
terraform {
  backend "s3" {
    bucket = "terraform-statefile-s3-bucket"
    key    = "s3/terraform.tfstate"
    region = "us-east-2"
  }
}

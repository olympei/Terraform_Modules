# Store terraform.tfstate in s3 bucket
terraform {
  backend "s3" {
    bucket = "terraform-statefile-s3-bucket"
    key    = "cloudfront/terraform.tfstate"
    region = "us-east-2"
  }
}

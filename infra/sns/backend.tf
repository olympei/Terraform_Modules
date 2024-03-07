# Store terraform.tfstate file s3
terraform {
  backend "s3" {
    bucket = "terra-bct"
    key    = "sns/terraform.tfstate"
    region = "us-east-1"
  }
}

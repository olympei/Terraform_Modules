# Store terraform.tfstate file s3
terraform {
  backend "s3" {
    bucket = "terraform-statefile-s3-bucket"
    key    = "sns/terraform.tfstate"
    region = "us-east-2"
  }
}

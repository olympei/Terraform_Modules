    terraform {
  backend "s3" {
    bucket = "tf-buckettt"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

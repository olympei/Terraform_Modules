# Data source for aws instance 
data "aws_instance" "my_instance" {
  // Filter instances based on tags, IDs, or other criteria
  filter {
    name   = "tag:Name"
    values = ["demo-ec2_public"]
  }
}

# Data source for aws sns topic
data "aws_sns_topic" "project_topic" {
  name = "project_topic"
}


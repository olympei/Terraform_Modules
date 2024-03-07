
# Define the SNS topic
resource "aws_sns_topic" "project_topic" {
  name = var.topic_name

}

# Define an email subscription
resource "aws_sns_topic_subscription" "project_topic_subscription" {
  topic_arn  = aws_sns_topic.project_topic.arn
  protocol   = var.subscription_protocol
  endpoint   = var.subscription_endpoint

}   
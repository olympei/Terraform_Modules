# The output for EC2 instance ID
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = data.aws_instance.my_instance.id
}

# The output for SNS topic ARN
output "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = data.aws_sns_topic.project_topic.arn
}

# Create resource aws cloudwatch cpu metric alarm
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = var.cpu_alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300" #5 minutes
  statistic           = "Average"
  threshold           = "30"
  alarm_description   = "Alarm when CPU exceeds 30%"
  dimensions = {
    InstanceId = data.aws_instance.my_instance.id
  }

  alarm_actions = [data.aws_sns_topic.project_topic.arn]  # SNS topic for notifications
}

# Create resource aws cloudwatch metric Memory Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "memory_alarm" {
  alarm_name          = var.memory_alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization" # Assuming this is the correct metric name for memory utilization
  namespace           = "System/Linux"      # Adjust the namespace based on the service providing memory metrics
  period              = "300"                 # 5 minutes
  statistic           = "Average"
  threshold           = "30"                 # Adjust threshold as per your requirements
  alarm_description   = "Alarm when Memory exceeds 30%"
  dimensions = {
    InstanceId = data.aws_instance.my_instance.id
  }
  alarm_actions = [data.aws_sns_topic.project_topic.arn]  # SNS topic for notifications
}

# Create resource aws cloudwatch metric Disk Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "disk_alarm" {
  alarm_name          = var.disk_alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DiskSpaceUtilization"   
  namespace           = "System/Linux"     # Adjust the namespace based on the service providing disk metrics
  period              = "300"                # 5 minutes
  statistic           = "Average"
  threshold           = "30"                # Adjust threshold as per your requirements
  alarm_description   = "Alarm when Disk exceeds 30%"
  dimensions = {
    InstanceId = data.aws_instance.my_instance.id
  }
  alarm_actions = [data.aws_sns_topic.project_topic.arn]  # SNS topic for notifications
}


#--------------------------------------------------------------------------------------------------------------
#Create cloudwatch Dashboard
#--------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_dashboard" "demo_dashboard" {
  dashboard_name = "demo-dashboard-${data.aws_instance.my_instance.id}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              "${data.aws_instance.my_instance.id}"
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "${data.aws_instance.my_instance.id} - CPU Utilization"
        }
      },
      {
        type   = "text"
        x      = 0
        y      = 7
        width  = 3
        height = 3

        properties = {
          markdown = "My Demo Dashboard"
        }
      },

      {
        type   = "metric"
        x      = 6
        y      = 0
        width  = 6
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "MemoryUtilization",
              "InstanceId",
              "${data.aws_instance.my_instance.id}"
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "${data.aws_instance.my_instance.id} - Memory Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 6
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "DiskUtilization",
              "InstanceId",
              "${data.aws_instance.my_instance.id}"
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "${data.aws_instance.my_instance.id} - Disk Utilization"
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "NetworkIn",
              "InstanceId",
              "${data.aws_instance.my_instance.id}"
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "${data.aws_instance.my_instance.id} - NetworkIn"
        }
      }
    ]
  })
}


#-----------------------------------------------------------------------------------------------
#create cloudwatch event 
#-----------------------------------------------------------------------------------------------

# CloudWatch Event Rule to capture AWS Console Sign-Ins
resource "aws_cloudwatch_event_rule" "console" {
  name        = "capture-aws-sign-in"
  description = "Capture each AWS Console Sign In"

  event_pattern = jsonencode({
    "detail-type" : [
      "AWS Console Sign In via CloudTrail"
    ]
  })
}

# CloudWatch Event Target to send events to the existing SNS topic
resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.console.name
  target_id = "SendToSNS"
  arn       = data.aws_sns_topic.project_topic.arn  # Use the ARN of the existing SNS topic
}

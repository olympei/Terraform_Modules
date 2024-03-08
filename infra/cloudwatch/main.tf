module "cloudwatch_alarms" {
  source = "../../module/cloudwatch"

  cpu_alarm_name = var.cpu_alarm_name
  memory_alarm_name = var.memory_alarm_name
  disk_alarm_name = var.disk_alarm_name
  region = var.region

}

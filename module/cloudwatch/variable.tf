# Define variable for cpu alarm name
variable "cpu_alarm_name" {
    type = string
    default = ""
  
}

# Define variable for memory alarm name
variable "memory_alarm_name" {
    type = string
    default = ""
  
}

# Define variable for disk alarm name
variable "disk_alarm_name" {

    type = string
    default = ""
}

# Define variable for region
variable region {
  type        = string
  default     = ""
  description = "description"
}


variable "namespace" {
  description = "The namespace to use for tagging resources"
  type        = string
  default     = ""
}
# Define variable for EC2 instance type
variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "" # Default instance type is t2.micro
}



variable "private_server_instance_type" {
  type = string
  default = ""
  
}

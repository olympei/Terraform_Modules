# The namespace to use for tagging resources
variable "namespace" {
  description = "The namespace to use for tagging resources"
  type        = string
  default     = ""
}
# Define variable for public EC2 instance type
variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "" # Default instance type is t2.micro
}

# Define variable for private EC2 instance type
variable "private_server_instance_type" {
  type = string
  default = ""
  
}

# ec2 instance key name
variable key_name {
  type        = string
  default     = ""
  description = "The key name"
}



variable "namespace" {
  description = "The namespace to use for tagging resources"
  type        = string
  default     = null
}
# Define variable for EC2 instance type
variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = null 
}


variable "key_name" {
  description = "Name of the key pair used for the EC2 instance"
  type        = string
  default     = ""  # Provide a default value if needed
}


variable "private_server_instance_type" {
  type = string
  default = ""
  
}

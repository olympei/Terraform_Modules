# Define variable for alb name
variable "alb_name" {
    type = string
    default = ""
  
}
# Define variable for target group tag name
variable "tg_name" {
    type = string
    default = ""
  
}

# Define variable for load balancer type
variable "load_balancer_type" {
    type = string
    default = ""
  
}
# Define variable for private key path
variable "private_key_path" {
    type = string

    default = ""
                                
}
# Define variable for alb port
variable "alb_port" {
    type = number
    default = 80
  
}
# Define variable for alb protocol
variable "alb_protocol" {
  type = string
  default = ""  
  
}

# Define variable for alb action type
variable "alb_action_type" {
    type = string
    default = ""
}

# Define variable for
variable "alb_target_group_protocol" {
  type = string
  default = ""
}
# Define variable for The port number for the target group
variable "aws_lb_target_group_port" {
  description = "The port number for the target group."
  type        = number
  default     = "80"
}

variable "alb_name" {
    type = string
    default = ""
  
}

variable "is_internal" {
    type = bool
    default = "false" 
}
variable "tg_name" {
    type = string
    default = ""
  
}
variable "instance_type" {
    type = string
    default = ""
  
}
variable "key_name" {
    type = string
    default = ""
  
}

variable "load_balancer_type" {
    type = string
    default = ""
  
}

variable "private_key_path" {
    type = string

    default = ""
                                
}
variable "alb_port" {
    type = number
    default = 80
  
}


variable "alb_protocol" {
  type = string
  default = ""  
  
}


variable "alb_action_type" {
    type = string
    default = ""
}


variable "ami_id" {
    type = string
    default = ""
}  

variable "ec2_tag" {
  type = string
  default = ""
}

variable "aws_lb_target_group_port" {
    type = number
    default = 80
  
}

variable "alb_target_group_protocol" {
  type = string
  default = ""
}

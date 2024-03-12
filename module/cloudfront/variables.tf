# Define variable for to view all the content to everyone 
variable "viewer_protocol_policy" {
    type = string
    default = null
  
}
#Define variable to the min amount of object that you want to stay in cdn caches
variable "min_ttl" {
    type = number
    default = null
  
}
#Define variable to the default amount of object that you want to stay in cdn caches
variable "default_ttl" {
    type = number
    default = null
  
}
#Define variable to the max amount of object that you want to stay in cdn caches
variable "max_ttl" {
    type = number
    default = null
  
}
#Define all edge locations provides the best performance for all viewers
variable "price_class" {
    type = string
    default = ""
  
}

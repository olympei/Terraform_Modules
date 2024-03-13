# Define variable for domain name 
variable "domain_name" {
  description = "The domain name for which to request the ACM certificate"
  type        = string
  default     = null
}
# Define variable for domain validation method
variable "validation_method" {
  description = "The validation method to use for ACM certificate validation (e.g., EMAIL, DNS)"
  type        = string
  default     = null
}
# Define variable for domain alternative name
variable "alternative_name" {
  type        = string
  default     = null
  description = "omain alternative name"
}

# sns topic name
variable "topic_name" {
  description = "The name of the SNS topic."
  type        = string
  default     = ""
}

# sns topic subscription protocol
variable "subscription_protocol" {
  description = "The protocol for the subscription (e.g., email, sms)."
  type        = string
  default     = ""
}

# sns topic subscription endpoint
variable "subscription_endpoint" {
  description = "The endpoint for the subscription (e.g., email address, phone number)."
  type        = string
  default     = ""
}


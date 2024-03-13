# This section defines the outputs for the ACM certificate ARN 
output "certificate_arn" {
  value = aws_acm_certificate.acm_cert.arn
}

# This section defines the outputs for the domain name
output domain_name {
  value       = var.domain_name
}



resource "aws_acm_certificate" "acm_cert" {
  domain_name       = var.domain_name
  validation_method = var.validation_method
  subject_alternative_names = [var.alternative_name]

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "ACM Certificate for ${var.domain_name}"
    Environment = "Production"
    Owner       = "YourName"
  }
}


# get details about a route 53 hosted zone
data "aws_route53_zone" "route53_zone" {
  name         = var.domain_name
  private_zone = false
}

# create a record set in route 53 for domain validatation ["dvo" = domain validatation option ]
resource "aws_route53_record" "route53_record" {
  for_each = {
    for dvo in aws_acm_certificate.acm_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  # allowing overwriting existing records if any.
  allow_overwrite = true #{Specifies whether to allow overwriting existing records. It's set to = true}
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route53_zone.zone_id
}

# validate acm certificates { validates the ACM certificate by creating DNS validation records in Route 53.}
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.acm_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_record : record.fqdn]
  #fully qualified domain names (fqdn)
}

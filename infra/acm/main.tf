module "acm" {
  source = "../../module/acm"
  domain_name = var.domain_name
  validation_method = var.validation_method
  alternative_name  = var.alternative_name
}

module "cloudfront" {
    source = "../../module/cloudfront"
    viewer_protocol_policy = var.viewer_protocol_policy
    price_class = var.price_class
}

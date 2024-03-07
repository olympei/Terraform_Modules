module "sns" {

   source = "../../module/sns"
   topic_name = var.topic_name
   subscription_protocol = var.subscription_protocol
   subscription_endpoint = var.subscription_endpoint
}

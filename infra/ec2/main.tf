module "ec2" {

  source = "../../module/ec2"
  instance_type = var.instance_type
  namespace = var.namespace
  private_server_instance_type = var.private_server_instance_type
  key_name = var.key_name
} 


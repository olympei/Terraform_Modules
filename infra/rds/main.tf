
module "rds" {
  
  source = "../../module/rds"
  db_instance_identifier = var.db_instance_identifier
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  db_name = var.db_name
  engine = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  username = var.username
  password = var.password
  publicly_accessible = var.publicly_accessible
  storage_type = var.storage_type
  


}

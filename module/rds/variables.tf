# Define variable for db instance identifier
variable "db_instance_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
  default = null
  
}
# Define variable for allocated_storage
variable "allocated_storage" {
  type        = number
  default     = null
  description = "allocates dtorage for rds instance"
}
# Define variable for
variable "max_allocated_storage" {
  type        = number
  default     = null
  description = "allocates dtorage for rds instance"
}
# Define variable for
variable "db_name" {
  type        = string
  description = "describe db name details"
  default = null
}
# Define variable for
variable "engine" {
  type        = string
  default     = null
  description = "describe engine name for database"
}
# Define variable for
variable "engine_version" {
  type        = number
  default     = null
  description = "describe db engine version"
}
# Define variable for
variable "instance_class" {
  type        = string
  default     = null
  description = "describe db instance class"
}
# Define variable for
variable "username" {
  type        = string
  default     = null
  description = "set username for database"
}
# Define variable for
variable "password" {
  type        = string
  default     = null
  description = "set password for database"
}

# Define variable for publicly_accessible
variable "publicly_accessible" {
  type        = bool
  default     = null
  description = "set publicly_accessible for db instance"
}
# Define variable for storage_type
variable "storage_type" {
  type        = string
  default     = null
  description = "set storage type for db instance"
}
# Define variable for final snapshot identifier name
variable "final_snapshot_identifier" {
  type        = string
  default     = null
  description = "final snapshot identifier name"
}


# Define variable for skip final snapshot
variable "skip_final_snapshot" {
  type        = bool
  description = "set final snapshot details"
  default = null
}

# Define variable for db subnet group name
variable "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  type        = string
  default = null
}
# Define variable for db security group name
variable "db_security_group_name" {
  type        = string
  default     = ""
  description = "db security group name"
}

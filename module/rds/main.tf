
# Create db instance
resource "aws_db_instance" "prod-rds" {
  
   
  identifier                   = var.db_instance_identifier
  allocated_storage            = var.allocated_storage
  max_allocated_storage        = var.max_allocated_storage
  db_name                      = var.db_name
  final_snapshot_identifier    = var.final_snapshot_identifier
  engine                       = var.engine
  engine_version               = var.engine_version
  instance_class               = var.instance_class
  username                     = var.username
  password                     = var.password
  publicly_accessible          = var.publicly_accessible
  storage_type                 = var.storage_type
  availability_zone            = element(data.aws_availability_zones.available.names,0) 
  storage_encrypted            = true
  allow_major_version_upgrade  = true
  apply_immediately            = true
  deletion_protection          = false 
  skip_final_snapshot          = true
  # Specify the subnet group
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  # Specify the security groups
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
      Environment = "Production"
      Application = "MyApp"
  }
}

# Create RDS subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_subnet_group_name 
  subnet_ids = data.aws_subnets.public_subnet.ids
  
    tags = {
    Name        = "MyDBSubnetGroup"
    Environment = "Production"
 }
}
# Create security group for db instance
resource "aws_security_group" "db_sg" {
  name = var.db_security_group_name
  description = "security group for db instance"
  vpc_id = data.aws_vpc.main-vpc.id

  tags = {
    Name        = "MyDBSecurityGroup"
    Environment = "Production"
  }
# Define ingress rules
  ingress {
    description = "Allow inbound traffic on PostgreSQL port"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow access from anywhere. Adjust as per your network requirements.
  }

  # Define egress rules
  egress {
    description = "Allow outbound traffic to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound traffic to anywhere. Adjust as per your network requirements.
  }
}



# Create vpc resource
resource "aws_vpc" "my_vpc" {
  cidr_block                           = var.cidr
  instance_tenancy                     = "default"
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  
  tags = {
    Name = var.tag
  }
}

# Create public subnets
resource "aws_subnet" "public_subnet" {
  count = length(data.aws_availability_zones.available.names)
  availability_zone                              = element(data.aws_availability_zones.available.names,count.index)
  cidr_block                                     = cidrsubnet(var.cidr,4,count.index)
  vpc_id                                         = aws_vpc.my_vpc.id
  
    tags = merge({
      Name = "public_subnet-${count.index + 1}"
}
    )
}

# Create public route table
resource "aws_default_route_table" "public_rt" {   
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }


  tags = {
    Name = "public_rt"
  }
}

# Associate public subnets to public route table
resource "aws_route_table_association" "public_subnet_association" {
  count = length(data.aws_availability_zones.available.names)
  subnet_id = element(aws_subnet.public_subnet[*].id,count.index)
  route_table_id = aws_default_route_table.public_rt.id
}

# Create Internet-Gateway and attach to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "internet_gateway"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnet" {
  count = length(data.aws_availability_zones.available.names)
  availability_zone                              = element(data.aws_availability_zones.available.names,count.index)
  cidr_block                                     = cidrsubnet(var.cidr,4,count.index + length(data.aws_availability_zones.available.names))
  vpc_id                                         = aws_vpc.my_vpc.id
  
    tags = merge({
      Name = "private_subnet-${count.index + 1}"
}
    )
}

# Create Elastic ip
resource "aws_eip" "elastic_ip" {
  domain = "vpc"

    tags = {
    Name = "elastic_ip"
  }
}

# Create Nat-Gateway and allocate Elastic ip
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet[1].id

  tags = {
    Name = "nat_gateway"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

# Create private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private-rt"
  }
  depends_on = [aws_internet_gateway.internet_gateway]
} 

# associate private subnets to private route table 
resource "aws_route_table_association" "private_subnet_association" {
  count = length(data.aws_availability_zones.available.names)
  subnet_id = element(aws_subnet.private_subnet[*].id,count.index)
  route_table_id = aws_route_table.private_rt.id
}


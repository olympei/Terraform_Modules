resource "aws_vpc" "main_vpc" {
  cidr_block                           = var.cidr
  instance_tenancy                     = "default"
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  
  tags = {
    Name = var.tag
  }
}


resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.available.names)
  availability_zone                              = element(data.aws_availability_zones.available.names,count.index)
  cidr_block                                     = cidrsubnet(var.cidr,4,count.index)
  vpc_id                                         = aws_vpc.main_vpc.id
  
    tags = merge({
      Name = "public_subnet-${count.index + 1}"
}
    )
}


resource "aws_default_route_table" "publi_rt" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }


  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count = length(data.aws_availability_zones.available.names)
  subnet_id = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_default_route_table.publi_rt.id
}
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_subnet" "private" {
  count = length(data.aws_availability_zones.available.names)
  availability_zone                              = element(data.aws_availability_zones.available.names,count.index)
  cidr_block                                     = cidrsubnet(var.cidr,4,count.index + length(data.aws_availability_zones.available.names))
  vpc_id                                         = aws_vpc.main_vpc.id
  
    tags = merge({
      Name = "private_subnet-${count.index + 1}"
}
    )
}

resource "aws_eip" "elastic_ip" {
  domain = "vpc"
  # vpc    = "true"

    tags = {
    Name = "elastic_ip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public[1].id

  tags = {
    Name = "nat_gateway"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private_rt"
  }
  depends_on = [aws_internet_gateway.internet_gateway]
} 

resource "aws_route_table_association" "private_subnet_association" {
  count = length(data.aws_availability_zones.available.names)
  subnet_id = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private_rt.id
}

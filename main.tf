# VPC 
resource "aws_vpc" "lms-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lms-vpc"
  }
}

# PUBLIC SUBNET
resource "aws_subnet" "lms-pub-sn" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "lms-pub-subnet"
  }
}

# PRIVATE SUBNET
resource "aws_subnet" "lms-pvt-sn" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-1c"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "lms-pvt-subnet"
  }
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "lms-igw" {
  vpc_id = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-internet-gateway"
  }
}

# PUBLIC ROUTE TABLE
resource "aws_route_table" "lms-pub-rt" {
  vpc_id = aws_vpc.lms-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lms-igw.id
  }

  tags = {
    Name = "lms-pub-route-table"
  }
}

# PUBLIC ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "lms-pub-rt-association" {
  subnet_id      = aws_subnet.lms-pub-sn.id
  route_table_id = aws_route_table.lms-pub-rt.id
}
# ELASTIC IP
resource "aws_eip" "lms-eip" {
  domain   = "vpc"
  tags = {
    Name = "lms eip"
  }
}

# NAT GATEWAY
resource "aws_nat_gateway" "lms-nat" {
  allocation_id = aws_eip.lms-eip.id
  subnet_id     = aws_subnet.lms-pub-sn.id

  tags = {
    Name = "lms-nat-gateway"
  }
}

# PRIVATE ROUTE TABLE
resource "aws_route_table" "lms-pvt-rt" {
  vpc_id = aws_vpc.lms-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.lms-nat.id
  }
  tags = {
    Name = "lms-pvt-route-table"
  }
}

# PRIVATE ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "lms-pvt-rt-association" {
  subnet_id      = aws_subnet.lms-pvt-sn.id
  route_table_id = aws_route_table.lms-pvt-rt.id
}

# PUBLIC NACL
resource "aws_network_acl" "lms-pub-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-pub-nacl"
  }
}

# PUBLIC NACL ASSOCIATION
resource "aws_network_acl_association" "lms-pub-nacl-association" {
  network_acl_id = aws_network_acl.lms-pub-nacl.id
  subnet_id      = aws_subnet.lms-pub-sn.id
}

# PRIVATE NACL
resource "aws_network_acl" "lms-pvt-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-pvt-nacl"
  }
}

# PRIVATE NACL ASSOCIATION
resource "aws_network_acl_association" "lms-pvt-nacl-association" {
  network_acl_id = aws_network_acl.lms-pvt-nacl.id
  subnet_id      = aws_subnet.lms-pvt-sn.id
}


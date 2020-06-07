resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name      = var.name
    Terraform = true
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = var.name
    Terraform = true
  }
}

resource "aws_eip" "eip" {
  vpc = true
  depends_on = [
    aws_internet_gateway.internet_gateway
  ]
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name      = var.name
    Terraform = true
  }

  depends_on = [
  aws_internet_gateway.internet_gateway]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name      = "${var.name}-public-rt"
    Terraform = true
  }
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    from_port  = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    to_port    = 0
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name      = "${var.name}-default-acl"
    Terraform = true
  }

}
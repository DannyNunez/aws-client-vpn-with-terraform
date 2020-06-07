resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr_blocks.public_a.cidr_block
  availability_zone       = var.subnet_cidr_blocks.public_a.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name              = "${var.name}-public"
    Terraform         = true
    SubnetType        = "public"
    Availability_Zone = var.subnet_cidr_blocks.public_a.availability_zone
    Environment       = var.environment
  }
}

resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_blocks.private_a.cidr_block
  availability_zone = var.subnet_cidr_blocks.private_a.availability_zone

  tags = {
    Name              = "${var.name}-private"
    Terraform         = true
    SubnetType        = "private"
    Availability_Zone = var.subnet_cidr_blocks.private_a.availability_zone
    Environment       = var.environment
  }
}

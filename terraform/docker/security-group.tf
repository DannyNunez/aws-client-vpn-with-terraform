resource "aws_security_group" "docker" {

  name   = var.security_group_name
  vpc_id = data.aws_vpc.this.id


  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = var.security_group_name
    Environment = var.environment
    Terraform   = true
  }
}
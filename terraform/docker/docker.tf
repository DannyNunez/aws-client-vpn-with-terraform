resource "aws_instance" "docker" {
  instance_type               = var.instance_type
  ami                         = var.ami
  associate_public_ip_address = false
  tags = {
    Name        = var.name
    Environment = var.environment
    Terraform   = true
    Role        = "docker"
  }

  root_block_device {
    encrypted             = true
    delete_on_termination = true
    volume_size           = "8"
  }

  iam_instance_profile   = aws_iam_instance_profile.instance.name
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.docker.id]
  subnet_id              = data.aws_subnet.private_subnet.id
  depends_on             = [aws_iam_instance_profile.instance]

}


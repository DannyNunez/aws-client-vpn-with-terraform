variable "environment" {}

variable "region" {}

variable "profile" {}

variable "private_subnet_a_av" {
  default = "us-east-1b"
}

variable "security_group_name" {
  default = "docker"
}

variable "name" {
  default = "docker"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {
  // Amazon Linux 2 AMI (HVM), SSD Volume Type
  default = "ami-0323c3dd2da7fb37d"
}

variable "key_name" {
  default = "dev"
}


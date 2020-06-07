variable "environment" {
}

variable "region" {}

variable "account_id" {}

variable "profile" {}

variable "name" {
  default = "dev"
}

variable "cidr_block" {
  default = "10.200.0.0/16"
}

variable "subnet_cidr_blocks" {
  type = map
  default = {
    public_a = {
      cidr_block        = "10.200.0.0/17"
      availability_zone = "us-east-1a"
    }
    private_a = {
      cidr_block        = "10.200.128.0/17"
      availability_zone = "us-east-1b"
    }
  }
}
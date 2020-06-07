terraform {
  required_version = ">= 0.12.24"
  backend "s3" {
  }
}

provider "aws" {
  version = ">= 2.59.0"
  profile = var.profile
  region  = var.region
}

resource "aws_key_pair" "ansible" {
  key_name   = var.name
  public_key = file(var.public_key_path)
}

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

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.environment]
  }
}

data "aws_subnet" "private_subnet" {
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }

  filter {
    name   = "tag:SubnetType"
    values = ["private"]
  }

  filter {
    name   = "tag:Availability_Zone"
    values = [var.private_subnet_a_av]
  }
}
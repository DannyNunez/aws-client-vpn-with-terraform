terraform {
  required_version = ">= 0.12.24"
  backend "s3" {
  }
}

provider "aws" {
  version = "~> 2.30"
  profile = "default"
  region  = var.region
}
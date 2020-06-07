inputs = {
  environment = "dev"
  region = "us-east-1"
  key_name  = "dev"
  profile   = "default"
}

remote_state {
  backend = "s3"
  config = {
    bucket = "client-vpn-endpoint-terraform-state"
    key = "terraform/${path_relative_to_include()}/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-state"
  }
}
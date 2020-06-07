variable "environment" {}

variable "region" {}

variable "profile" {}

variable "name" {
  default = "dev"
}
variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
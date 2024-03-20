variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "name_prefix" {
  type = string
  default = "wireapps"
}

variable "vpc" {
  type = map(any)
  default = {
    name = ["dev"]
    cidr = ["10.0.0.0/16"]
    private_subnet_cidrs = ["10.0.2.0/24", "10.0.4.0/24"]
    public_subnet_cidrs  = ["10.0.10.0/24", "10.0.20.0/24"]
  }
}
variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_name" {
  type = string
}

variable "ingress_cidr" {
  type = string
}

variable "vpc_id" {
  type    = string
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Public Subnet ids"
}
variable "app_name" {
  type = string
}

variable "docker_context_path" {
  type = string
}

variable "container_port" {
  type = number
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_database" {
  type = string
}

variable "db_host" {
  type = string
}

variable "api_host" {
  type = string
}

variable "public_subnet_id" {
  type        = list(string)
  description = "Public Subnet ids"
}

variable "ingress_cidr" {
  type = string
}

variable "vpc_id" {
  type    = string
}

variable "cluster_id" {
  type    = string
}

variable "listener_arn" {
  type    = string
}

variable "rule_priority" {
  type    = number
}

variable "app_context_path" {
  type = string
}

variable "health_check_path" {
  type = string
}
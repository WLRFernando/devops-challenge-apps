data "aws_region" "current" {}

module "vpc" {
  source               = "./modules/network"
  vpc_name             = var.vpc.name[0]
  region               = data.aws_region.current.name
  vpc_cidr_block       = var.vpc.cidr[0]
  private_subnet_cidrs = var.vpc.private_subnet_cidrs
  public_subnet_cidrs  = var.vpc.public_subnet_cidrs
}

module "alb" {
  source           = "./modules/alb"
  public_subnet_id = [for subnet in module.vpc.public_subnets : subnet.id]
  alb_name         = "${var.name_prefix}-alb"
  region           = data.aws_region.current.name
  vpc_id           = module.vpc.vpc_id

}

module "rds" {
  source             = "./modules/rds"
  db_name            = "${var.name_prefix}db"
  db_username        = var.db_username
  db_password        = var.db_password
  ingress_cidr       = var.vpc.cidr[0]
  private_subnet_ids = [for subnet in module.vpc.public_subnets : subnet.id]
  vpc_id             = module.vpc.vpc_id
}

module "cluster" {
  source       = "./modules/cluster"
  cluster_name = "${var.name_prefix}-cluster"
}

module "web_service" {
  source              = "./modules/fargate"
  docker_context_path = "../web/"
  app_name            = "${var.name_prefix}-web"
  api_host            = "http://${module.alb.alb-dns}"
  db_database         = ""
  db_host             = ""
  db_password         = ""
  db_user             = ""
  container_port      = 3000
  ingress_cidr        = var.vpc.cidr[0]
  vpc_id              = module.vpc.vpc_id
  cluster_id          = module.cluster.id
  listener_arn        = module.alb.listener-arn
  rule_priority       = 200
  app_context_path    = "/*"
  public_subnet_id    = [for subnet in module.vpc.public_subnets : subnet.id]
  health_check_path   = "/"
}

module "api_service" {
  source              = "./modules/fargate"
  docker_context_path = "../api/"
  app_name            = "${var.name_prefix}-api"
  api_host            = "http://${module.alb.alb-dns}"
  db_database         = "postgres"
  db_host             = module.rds.rds_endpoint
  db_password         = var.db_password
  db_user             = var.db_username
  container_port      = 3000
  ingress_cidr        = var.vpc.cidr[0]
  vpc_id              = module.vpc.vpc_id
  cluster_id          = module.cluster.id
  listener_arn        = module.alb.listener-arn
  rule_priority       = 100
  app_context_path    = "/api/*"
  public_subnet_id    = [for subnet in module.vpc.public_subnets : subnet.id]
  health_check_path   = "/api/status"
}
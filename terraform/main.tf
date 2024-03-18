data "aws_region" "current" {}

module "vpc" {
  source               = "./modules/network"
  vpc_name             = "dev"
  region               = data.aws_region.current.name
  vpc_cidr_block       = "10.0.0.0/16"
  private_subnet_cidrs = ["10.0.2.0/24", "10.0.4.0/24"]
  public_subnet_cidrs  = ["10.0.10.0/24", "10.0.20.0/24"]
}

module "alb" {
  source           = "./modules/alb"
  public_subnet_id = [for subnet in module.vpc.public_subnets : subnet.id]
  alb_name         = "wireapps-alb"
  region           = data.aws_region.current.name
  vpc_id           = module.vpc.vpc_id

}

module "web_service" {
  source              = "./modules/fargate"
  docker_context_path = "../web/"
  app_name            = "wireapps-web"
}

module "api_service" {
  source              = "./modules/fargate"
  docker_context_path = "../api/"
  app_name            = "wireapps-api"
}
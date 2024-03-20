data "aws_region" "current" {}

module "vpc" {
  source               = "./modules/network"
  vpc_name             = "dev-vm"
  region               = data.aws_region.current.name
  vpc_cidr_block       = "10.0.0.0/16"
  private_subnet_cidrs = ["10.0.6.0/24", "10.0.8.0/24"]
  public_subnet_cidrs  = ["10.0.30.0/24", "10.0.40.0/24"]
}

module "ec2" {
  source = "./modules/ec2"
  name = "wireapps"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0].id
  public_key = "./id_rsa_wireapps.pub"
}
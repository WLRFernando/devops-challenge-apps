output "vpc_cidr_block" {
  description = "VPC cidr block"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "alb-dns" {
  description = "ALB DNS endpoint"
  value       = module.alb.alb-dns
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.rds_endpoint
}
output "vpc_cidr_block" {
  description = "VPC cidr block"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "public_ip" {
  description = "EC2 public IP"
  value       = module.ec2.public_ip
}
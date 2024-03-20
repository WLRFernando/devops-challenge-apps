output "public_ip" {
  description = "EC2 public IP"
  value       = resource.aws_instance.web.public_ip
}
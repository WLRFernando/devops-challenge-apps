output "id" {
  description = "The ID of the load balancer"
  value       = aws_lb.my_alb.id
}

output "alb-arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.my_alb.arn
}

output "alb-dns" {
  description = "ALB DNS endpoint"
  value       = aws_lb.my_alb.dns_name
}

output "listener-arn" {
  description = "The ARN of the load balancer listner"
  value       = aws_lb_listener.front_end.arn
}
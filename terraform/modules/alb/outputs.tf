output "id" {
  description = "The ID of the load balancer"
  value       = aws_lb.my_alb.id
}

output "alb-arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.my_alb.arn
}

output "listener-arn" {
  description = "The ARN of the load balancer listner"
  value       = aws_lb_listener.front_end.arn
}
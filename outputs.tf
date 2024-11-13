output "main_ecs_service" {
  value       = aws_ecs_service.main
  description = "The mechanism by which a specified number of instances of a task definition can run and maintened simultaneously in an AWS ECS cluster."
}

output "ecs_security_group" {
  value       = aws_security_group.main_security_group
  description = "Corrresponding security group for ecs service"
}

output "ecs_service_policy" {
  value       = aws_appautoscaling_policy.main_ecs_service_appautoscaling_policy
  description = "ecs service policy for autoscaling"
}

output "ecs_service_autoscaling_target" {
  value       = aws_appautoscaling_target.main_ecs_service_appautoscaling_target
  description = "ecs service policy tagging with service"
}
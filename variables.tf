variable "name" {
  type        = string
  description = "Name of the service (up to 255 letters, numbers, hyphens, and underscores)"
}
variable "container_name" {
  type        = string
  description = "Name of the container to associate with the load balancer (as it appears in a container definition)."
}
variable "port" {
  type        = number
  description = "Port on the container to associate with the load balancer."
}
variable "cluster_name" {
  type        = string
  default     = null
  description = "ARN of an ECS cluster."
}
variable "iam_role" {
  type        = string
  default     = null
  description = "ARN of the IAM role that allows Amazon ECS to make calls to your load balancer on your behalf. This parameter is required if you are using a load balancer with your service, but only if your task definition does not use the awsvpc network mode. If using awsvpc network mode, do not specify this role. If your account has already created the Amazon ECS service-linked role, that role is used by default for your service unless you specify a role here."
}
variable "launch_type" {
  type        = string
  default     = null
  description = "Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL. Defaults to EC2."
}
variable "desired_count" {
  type        = number
  default     = null
  description = "Number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the DAEMON scheduling strategy."
}
variable "network_configuration" {
  type = object({
    subnets          = list(string)
    assign_public_ip = bool
  })
  default     = null
  description = "Network configuration for the service. This parameter is required for task definitions that use the awsvpc network mode to receive their own Elastic Network Interface, and it is not supported for other network modes."
}
variable "target_group_arn" {
  type        = string
  default     = null
  description = "ARN of the Load Balancer target group to associate with the service."
}
variable "task_definition" {
  type        = string
  description = "Family and revision (family:revision) or full ARN of the task definition that you want to run in your service. Required unless using the EXTERNAL deployment controller. If a revision is not specified, the latest ACTIVE revision is used."
}


variable "tags" {
  type        = map(string)
  description = "Additional tags to add to the Open Search. By default, the module will add application-id, application, cost-center, env, service, version, and owner-email"
  default     = {}
}

variable "vpc_id" {
  type        = string
  description = "(Forces new aws_security_group resource) VPC ID of aws_security_group to be created for aws_ecs_service."
}

variable "ingress" {
  type = list(object({
    description    = optional(string)
    from_port      = number
    to_port        = number
    protocol       = string
    cidr_blocks    = optional(list(string))
    security_group = optional(string)

  }))
  description = "Ingress rules for aws_security_group associated with aws_ecs_service."
}
variable "egress" {
  type = list(object({
    description    = optional(string)
    from_port      = number
    to_port        = number
    protocol       = string
    cidr_blocks    = optional(list(string))
    security_group = optional(string)
  }))
  description = "Egress rules for aws_security_group associated with aws_ecs_service."
}

variable "service_autoscaling" {
  default = null
  type = object({
    policy_type        = string
    scalable_dimension = string
    service_namespace  = string
    target_tracking_scaling_policy_configuration = object({
      predefined_metric_specification = object({
        predefined_metric_type = string
      })
      target_value       = string
      scale_in_cooldown  = string
      scale_out_cooldown = string
    })
    max_capacity = number
    min_capacity = number
  })
  description = "Metadata about the aws_appautoscaling_policy associated with aws_ecs_service."
}

variable "deployment_circuit_breaker" {
  type = object({
    enable   = bool
    rollback = bool
  })
  default     = null
  description = "Configuration block for deployment circuit breaker.  Supports 'enable' to choose whether to enable the deployment circuit breaker logic for the service and 'rollback' to choose whether to enable Amazon ECS to roll back the service if a service deployment fails. If rollback is enabled, when a service deployment fails, the service is rolled back to the last deployment that completed successfully."
}

variable "wait_for_steady_state" {
  type        = bool
  description = "If true, Terraform will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing. Default false."
  default     = false
}
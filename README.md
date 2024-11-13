<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.28.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.28.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.main_ecs_service_appautoscaling_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.main_ecs_service_appautoscaling_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_security_group.main_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.main_security_group_rule_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.main_security_group_rule_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.application_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.application_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.cost_center](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.env](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.owner_email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the container to associate with the load balancer (as it appears in a container definition). | `string` | n/a | yes |
| <a name="input_egress"></a> [egress](#input\_egress) | Egress rules for aws\_security\_group associated with aws\_ecs\_service. | <pre>list(object({<br>    description    = optional(string)<br>    from_port      = number<br>    to_port        = number<br>    protocol       = string<br>    cidr_blocks    = optional(list(string))<br>    security_group = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Ingress rules for aws\_security\_group associated with aws\_ecs\_service. | <pre>list(object({<br>    description    = optional(string)<br>    from_port      = number<br>    to_port        = number<br>    protocol       = string<br>    cidr_blocks    = optional(list(string))<br>    security_group = optional(string)<br><br>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the service (up to 255 letters, numbers, hyphens, and underscores) | `string` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | Port on the container to associate with the load balancer. | `number` | n/a | yes |
| <a name="input_task_definition"></a> [task\_definition](#input\_task\_definition) | Family and revision (family:revision) or full ARN of the task definition that you want to run in your service. Required unless using the EXTERNAL deployment controller. If a revision is not specified, the latest ACTIVE revision is used. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Forces new aws\_security\_group resource) VPC ID of aws\_security\_group to be created for aws\_ecs\_service. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | ARN of an ECS cluster. | `string` | `null` | no |
| <a name="input_deployment_circuit_breaker"></a> [deployment\_circuit\_breaker](#input\_deployment\_circuit\_breaker) | Configuration block for deployment circuit breaker.  Supports 'enable' to choose whether to enable the deployment circuit breaker logic for the service and 'rollback' to choose whether to enable Amazon ECS to roll back the service if a service deployment fails. If rollback is enabled, when a service deployment fails, the service is rolled back to the last deployment that completed successfully. | <pre>object({<br>    enable   = bool<br>    rollback = bool<br>  })</pre> | `null` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the DAEMON scheduling strategy. | `number` | `null` | no |
| <a name="input_iam_role"></a> [iam\_role](#input\_iam\_role) | ARN of the IAM role that allows Amazon ECS to make calls to your load balancer on your behalf. This parameter is required if you are using a load balancer with your service, but only if your task definition does not use the awsvpc network mode. If using awsvpc network mode, do not specify this role. If your account has already created the Amazon ECS service-linked role, that role is used by default for your service unless you specify a role here. | `string` | `null` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL. Defaults to EC2. | `string` | `null` | no |
| <a name="input_network_configuration"></a> [network\_configuration](#input\_network\_configuration) | Network configuration for the service. This parameter is required for task definitions that use the awsvpc network mode to receive their own Elastic Network Interface, and it is not supported for other network modes. | <pre>object({<br>    subnets          = list(string)<br>    assign_public_ip = bool<br>  })</pre> | `null` | no |
| <a name="input_service_autoscaling"></a> [service\_autoscaling](#input\_service\_autoscaling) | Metadata about the aws\_appautoscaling\_policy associated with aws\_ecs\_service. | <pre>object({<br>    policy_type        = string<br>    scalable_dimension = string<br>    service_namespace  = string<br>    target_tracking_scaling_policy_configuration = object({<br>      predefined_metric_specification = object({<br>        predefined_metric_type = string<br>      })<br>      target_value       = string<br>      scale_in_cooldown  = string<br>      scale_out_cooldown = string<br>    })<br>    max_capacity = number<br>    min_capacity = number<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to add to the Open Search. By default, the module will add application-id, application, cost-center, env, service, version, and owner-email | `map(string)` | `{}` | no |
| <a name="input_target_group_arn"></a> [target\_group\_arn](#input\_target\_group\_arn) | ARN of the Load Balancer target group to associate with the service. | `string` | `null` | no |
| <a name="input_wait_for_steady_state"></a> [wait\_for\_steady\_state](#input\_wait\_for\_steady\_state) | If true, Terraform will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing. Default false. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_security_group"></a> [ecs\_security\_group](#output\_ecs\_security\_group) | Corrresponding security group for ecs service |
| <a name="output_ecs_service_autoscaling_target"></a> [ecs\_service\_autoscaling\_target](#output\_ecs\_service\_autoscaling\_target) | ecs service policy tagging with service |
| <a name="output_ecs_service_policy"></a> [ecs\_service\_policy](#output\_ecs\_service\_policy) | ecs service policy for autoscaling |
| <a name="output_main_ecs_service"></a> [main\_ecs\_service](#output\_main\_ecs\_service) | The mechanism by which a specified number of instances of a task definition can run and maintened simultaneously in an AWS ECS cluster. |
<!-- END_TF_DOCS -->
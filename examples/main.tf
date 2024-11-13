terraform {
  required_version = "~> 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "ce-ecs-service" {
  source                     = "../"
  for_each                   = var.terraform_ecs_service_module_configs
  name                       = lookup(each.value, "name")
  container_name             = lookup(each.value, "container_name")
  launch_type                = "FARGATE"
  desired_count              = lookup(each.value, "desired_count")
  port                       = lookup(each.value, "port")
  ingress                    = lookup(each.value, "ingress", null)
  egress                     = lookup(each.value, "egress", null)
  cluster_name               = each.value.cluster_name
  target_group_arn           = each.value.target_group_arn
  service_autoscaling        = lookup(each.value, "service_autoscaling", null)
  deployment_circuit_breaker = lookup(each.value, "deployment_circuit_breaker", null)
  network_configuration = {
    subnets          = var.subnets
    assign_public_ip = false
  }
  task_definition = lookup(each.value, "task_definition", null)
  vpc_id          = var.vpc_id
}
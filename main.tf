locals {
  tags = merge(var.tags, {
    application-id = data.aws_ssm_parameter.application_id.value
    application    = data.aws_ssm_parameter.application_name.value
    cost-center    = data.aws_ssm_parameter.cost_center.value
    env            = data.aws_ssm_parameter.env.value
    owner-email    = data.aws_ssm_parameter.owner_email.value
  })
}

resource "aws_ecs_service" "main" {
  name                  = var.name
  cluster               = var.cluster_name
  task_definition       = var.task_definition
  iam_role              = var.iam_role
  launch_type           = var.launch_type
  desired_count         = var.desired_count
  tags                  = merge(local.tags, { "resource-name" : "Amazon Elastic Container Service" })
  wait_for_steady_state = var.wait_for_steady_state
  dynamic "network_configuration" {
    for_each = (var.network_configuration != null) ? [var.network_configuration] : []
    content {
      subnets          = network_configuration.value.subnets
      security_groups  = [aws_security_group.main_security_group.id]
      assign_public_ip = network_configuration.value.assign_public_ip
    }
  }
  dynamic "load_balancer" {
    for_each = (var.target_group_arn != null) ? [var.target_group_arn] : []
    content {
      target_group_arn = load_balancer.value
      container_name   = var.container_name
      container_port   = var.port
    }
  }

  dynamic "deployment_circuit_breaker" {
    for_each = (var.deployment_circuit_breaker != null) ? [var.deployment_circuit_breaker] : []
    content {
      enable   = deployment_circuit_breaker.value.enable
      rollback = deployment_circuit_breaker.value.rollback
    }
  }
}

resource "aws_security_group" "main_security_group" {
  lifecycle {
    create_before_destroy = true
  }
  name   = "${var.name}-SG"
  vpc_id = var.vpc_id
  tags   = merge(local.tags, { "resource-name" : "Amazon Elastic Container Service" })
}

resource "aws_security_group_rule" "main_security_group_rule_ingress" {
  lifecycle {
    create_before_destroy = true
  }
  security_group_id        = aws_security_group.main_security_group.id
  for_each                 = { for index, ingress in var.ingress : index => ingress }
  type                     = "ingress"
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  source_security_group_id = each.value.security_group
}


resource "aws_security_group_rule" "main_security_group_rule_egress" {
  lifecycle {
    create_before_destroy = true
  }
  security_group_id        = aws_security_group.main_security_group.id
  for_each                 = { for index, egress in var.egress : index => egress }
  type                     = "egress"
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  source_security_group_id = each.value.security_group
}

resource "aws_appautoscaling_policy" "main_ecs_service_appautoscaling_policy" {
  count              = var.service_autoscaling != null ? 1 : 0
  name               = "${var.name}-autoscalingpolicy"
  policy_type        = var.service_autoscaling.policy_type
  resource_id        = "service/${aws_ecs_service.main.cluster}/${aws_ecs_service.main.name}"
  scalable_dimension = var.service_autoscaling.scalable_dimension
  service_namespace  = var.service_autoscaling.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.service_autoscaling.target_tracking_scaling_policy_configuration.predefined_metric_specification.predefined_metric_type
    }
    target_value       = var.service_autoscaling.target_tracking_scaling_policy_configuration.target_value
    scale_in_cooldown  = var.service_autoscaling.target_tracking_scaling_policy_configuration.scale_in_cooldown
    scale_out_cooldown = var.service_autoscaling.target_tracking_scaling_policy_configuration.scale_out_cooldown
  }
}

resource "aws_appautoscaling_target" "main_ecs_service_appautoscaling_target" {
  count              = var.service_autoscaling != null ? 1 : 0
  max_capacity       = var.service_autoscaling.max_capacity
  min_capacity       = var.service_autoscaling.min_capacity
  resource_id        = "service/${aws_ecs_service.main.cluster}/${aws_ecs_service.main.name}"
  scalable_dimension = var.service_autoscaling.scalable_dimension
  service_namespace  = var.service_autoscaling.service_namespace
}
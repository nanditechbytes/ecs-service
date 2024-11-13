variable "terraform_ecs_service_module_configs" {
  type = any
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}
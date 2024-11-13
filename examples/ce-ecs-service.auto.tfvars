terraform_ecs_service_module_configs = {
  myService = {
    name             = "myService"
    container_name   = "myContainer"
    target_group_arn = "Arn for TG"
    port             = 443
    desired_count    = 1
    ingress = [
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    cluster_name    = "myCluster"
    task_definition = "Arn Task Definition"
  }
}

vpc_id  = "vpc-0375de84a7fb55373"
subnets = ["subnet-004de0f3ead5fec01"]
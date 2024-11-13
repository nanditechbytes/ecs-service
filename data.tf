data "aws_ssm_parameter" "application_id" {
  name = "hccp-app-id"
}

data "aws_ssm_parameter" "application_name" {
  name = "hccp-app"
}

data "aws_ssm_parameter" "cost_center" {
  name = "hccp-cost-center"
}

data "aws_ssm_parameter" "env" {
  name = "hccp-environment"
}

data "aws_ssm_parameter" "owner_email" {
  name = "hccp-owner"
}
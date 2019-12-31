locals {
  common = yamldecode(file("./config/${get_env("ENVIRONMENT", "dev")}/common.yaml"))
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.common.env.bucket_terragrunt_state}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.common.env.region}"
    dynamodb_table = "${local.common.env.dynamodb_table}"
  }
}

iam_role = "arn:aws:iam::${get_aws_account_id()}:role/IacManagementRole"

locals {
  common = yamldecode(file("./common_vars.yaml"))
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.common.bucket_terragrunt_state}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.common.region}"
    dynamodb_table = "${local.common.dynamodb_table}"
  }
}

inputs = {
    region = "us-east-1"
}

iam_role = "arn:aws:iam::${get_aws_account_id()}:role/IacManagementRole"

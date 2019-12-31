locals {
  global = yamldecode(file("./config.yaml"))
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.global.bucket_terragrunt_state}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.global.region}"
    dynamodb_table = "${local.global.dynamodb_table}"
  }
}

iam_role = "arn:aws:iam::${get_aws_account_id()}:role/IacManagementRole"

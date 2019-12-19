# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = ""
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = ""
  }
}

iam_role = "arn:aws:iam::${get_aws_account_id()}:role/IacExecutionRole"

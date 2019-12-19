# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "br-com-k8sguru-terragrunt-state-prod"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "br-com-k8sguru-terragrunt-locks"
  }
}

iam_role = "arn:aws:iam::${get_aws_account_id()}:role/IacManagementRole"

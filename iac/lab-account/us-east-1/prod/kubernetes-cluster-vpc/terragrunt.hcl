

# Include module for aws vpc 
# See also https://github.com/terraform-aws-modules/terraform-aws-vpc
terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc//?ref=v2.15.0"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  region = "us-east-1"
}

inputs = {
  name = "kops-tutorial"
  cidr = "${local.common_vars.cidr}"

  azs             = "${local.common_vars.azs}"
  private_subnets = "${local.common_vars.private_subnets}"
  public_subnets  = "${local.common_vars.public_subnets}"

  enable_sagemaker_runtime_endpoint = false
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  tags = {
    Environment = "${local.common_vars.environment}"
    Application = "network"
    "kubernetes.io/cluster/${local.common_vars.cluster_name}" = "shared"
  }

}

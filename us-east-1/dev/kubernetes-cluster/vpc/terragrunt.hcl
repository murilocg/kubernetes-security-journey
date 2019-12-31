terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc//?ref=v2.15.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  cidr = "10.0.0.0/16"
  azs             = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
  private_subnets = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
  public_subnets  = [ "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

inputs = {
  name = "kops-${local.common.environment}"
  cidr = "10.0.0.0/16"
  azs             = "${local.azs}"
  private_subnets = "${local.private_subnets}"
  public_subnets  = "${local.public_subnets}"

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
    Environment = "${local.common.environment}"
    Application = "network"
    "kubernetes.io/cluster/${local.common.cluster_name}" = "${local.common.environment}"
  }
}

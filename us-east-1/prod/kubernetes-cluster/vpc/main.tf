terraform {
  backend "s3" {}
  required_version = ">= 0.12"
}

provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc//?ref=v2.15.0"
  name = "kops-${var.environment}"
  cidr = "${var.cidr}"
  azs             = "${var.azs}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

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
    Environment = "${var.environment}"
    Application = "network"
    "kubernetes.io/cluster/${var.cluster_name}" = "${var.environment}"
  }
}



terraform {
  source = "../../../../../terraform-modules//kops-cluster"
}


# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../kubernetes-cluster-vpc"]
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../kubernetes-cluster-vpc"
}

inputs = {
  cluster_name = "${local.common_vars.cluster_name}"
  environment = "${local.common_vars.environment}"
  bucket_name = "${local.common_vars.kops_state_bucket}"
  ingress_ips = "${local.common_vars.ingress_ips}"
  vpc_id = "${dependency.vpc.outputs.vpc_id}"
  vpc_filter = {
    Environment = "${local.common_vars.environment}"
    Application = "network"
    "kubernetes.io/cluster/${local.common_vars.cluster_name}" = "shared"
  }
}

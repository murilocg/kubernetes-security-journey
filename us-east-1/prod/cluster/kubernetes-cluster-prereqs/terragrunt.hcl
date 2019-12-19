

terraform {
  source = "../../../../../modules//kops-cluster"
}

include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  ingress_ips = ["10.0.0.100/32", "10.0.0.101/32"]
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../kubernetes-cluster-vpc"
}

inputs = {
  cluster_name = "${local.common.cluster_name}"
  environment = "${local.common.environment}"
  bucket_name = "${local.common.kops_state_bucket}"
  ingress_ips = "${local.ingress_ips}"
  vpc_id = "${dependency.vpc.outputs.vpc_id}"
  vpc_filter = {
    Environment = "${local.common.environment}"
    Application = "network"
    "kubernetes.io/cluster/${local.common.cluster_name}" = "shared"
  }
}

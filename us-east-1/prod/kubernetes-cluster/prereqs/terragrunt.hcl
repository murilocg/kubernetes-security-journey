include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../vpc"
  mock_outputs = {
    vpc_id = "vpc-2a999999"
  }
}

inputs = {
  cluster_name = local.common.cluster_name
  environment = local.common.environment
  region = local.common.region
  kops_state_bucket = local.common.kops_state_bucket
  ingress_ips = ["10.0.0.100/32", "10.0.0.101/32"]
  vpc_id = dependency.vpc.outputs.vpc_id
}

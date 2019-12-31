include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common.yaml")))
  cluster = yamldecode(file(find_in_parent_folders("cluster.yaml")))
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../vpc"
  mock_outputs = {
    vpc_id = "vpc-2a999999"
  }
  skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  cluster_name = local.cluster.name
  environment = local.common.env.name
  region = local.common.env.region
  kops_state_bucket = local.cluster.kops_state_bucket
  ingress_ips = local.common.prereqs.ingress_ips
  vpc_id = dependency.vpc.outputs.vpc_id
}

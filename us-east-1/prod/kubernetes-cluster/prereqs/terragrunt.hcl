include {
  path = find_in_parent_folders()
}

locals {
  path = "${find_in_parent_folders()}/../config/${get_env("ENVIRONMENT", "none")}"
  common = yamldecode(file("${local.path}/common.yaml"))
  cluster = yamldecode(file("${local.path}/cluster.yaml"))
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
  kops_state_bucket = local.cluster.kopsStateBucket
  ingress_ips = local.common.prereqs.ingressIps
  vpc_id = dependency.vpc.outputs.vpc_id
}


include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
  
  before_hook "render_cluster" {
    commands = ["plan"]
    execute = [
      "./scripts/render_cluster.sh",
      "${local.common.cluster_name}",
      "${local.common.kops_state_bucket}",
      "${local.common.public_zone_id}",
      "${local.common.environment}"
    ]
    run_on_error = false
  }

  before_hook "create_cluster" {
    commands = ["apply"]
    execute = [
      "./scripts/create_cluster.sh",
      "${local.common.cluster_name}",
      "${local.common.kops_state_bucket}"
    ]
    run_on_error = false
  }
  
  after_hook "export_kubeconfig" {
    commands = ["apply"]
    execute = [
      "./scripts/export_kubeconfig.sh",
      "${local.common.cluster_name}",
      "${local.common.kops_state_bucket}",
      "${local.common.config_path}/kube/config"
    ]
    run_on_error = false
  }
}

dependency "prereqs" {
  config_path = "${get_terragrunt_dir()}/../prereqs"
}

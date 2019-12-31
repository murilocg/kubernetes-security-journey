
include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common.yaml")))
  cluster = yamldecode(file(find_in_parent_folders("cluster.yaml")))
  path_cluster_config = find_in_parent_folders("cluster.yaml")
}

terraform {
  
  before_hook "render_cluster" {
    commands = ["plan"]
    execute = [
      "./scripts/render_cluster.sh",
      "${local.cluster.name}",
      "${local.cluster.kops_state_bucket}",
      "${local.common.zone.public_zone_id}",
      "${local.common.env.name}"
      "${local.path_cluster_config}"
    ]
    run_on_error = false
  }
  
  after_hook "export_kubeconfig" {
    commands = ["apply"]
    execute = [
      "./scripts/export_kubeconfig.sh",
      "${local.cluster.name}",
      "${local.cluster.kops_state_bucket}",
      "${local.cluster.kube_config}"
    ]
    run_on_error = false
  }
}

dependency "prereqs" {
  config_path = "${get_terragrunt_dir()}/../prereqs"
  skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan"]
}

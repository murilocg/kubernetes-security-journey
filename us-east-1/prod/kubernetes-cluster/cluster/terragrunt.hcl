
include {
  path = find_in_parent_folders()
}

locals {
  path = "${find_in_parent_folders()}/../config/${get_env("ENVIRONMENT", "none")}"
  path_cluster_config = "${local.path}/cluster.yaml"
  common = yamldecode(file("${local.path}/common.yaml"))
  cluster = yamldecode(file("${local.path_cluster_config }"))
}

terraform {
  
  before_hook "render_cluster" {
    commands = ["plan"]
    execute = [
      "./scripts/render_cluster.sh",
      "${local.cluster.name}",
      "${local.cluster.kopsStateBucket}",
      "${local.common.zone.id}",
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
      "${local.cluster.kopsStateBucket}",
      "${local.cluster.kubeConfig}"
    ]
    run_on_error = false
  }
}

dependency "prereqs" {
  config_path = "${get_terragrunt_dir()}/../prereqs"
  skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan"]
}

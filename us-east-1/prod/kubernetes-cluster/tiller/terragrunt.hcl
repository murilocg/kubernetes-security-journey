include {
  path = find_in_parent_folders()
}

locals {
  path = "${find_in_parent_folders()}/../config/${get_env("ENVIRONMENT", "none")}"
  common = yamldecode(file("${local.path}/common.yaml"))
  cluster = yamldecode(file("${local.path}/cluster.yaml"))
}

terraform {
  after_hook "gen_cert" {
    commands = ["apply"]
    execute = ["./scripts/gencerts.sh", "${local.common.tiller.helmHome}"]
  }
}

dependency "cluster" {
  config_path = "${get_terragrunt_dir()}/../cluster"
  skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  kube_config = "${local.cluster.kubeConfig}"
}
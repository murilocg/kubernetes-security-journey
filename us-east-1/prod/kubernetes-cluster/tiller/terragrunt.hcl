include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
  after_hook "gen_cert" {
    commands = ["apply"]
    execute = ["./scripts/gencerts.sh", "${local.common.config_path}/secrets"]
  }
}

dependency "cluster" {
  config_path = "${get_terragrunt_dir()}/../cluster"
}

input {
  kubectl_config_path = "${local.common.config_path}/kube/config"
}
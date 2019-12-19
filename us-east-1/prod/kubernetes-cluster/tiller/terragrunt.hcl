include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
  after_hook "gen_cert" {
    commands = ["apply"]
    execute = ["./scripts/gencerts.sh"]
  }
}

dependency "cluster" {
  config_path = "${get_terragrunt_dir()}/../kubernetes-cluster"
}

input {
  kubectl_config_path = local.common.kubectl_config_path
}
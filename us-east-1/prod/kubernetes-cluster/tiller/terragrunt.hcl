include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
  after_hook "gen_cert" {
    commands = ["apply"]
    execute = ["./scripts/gencerts.sh", "${local.common.helm_home}"]
  }
}

dependency "cluster" {
  config_path = "${get_terragrunt_dir()}/../cluster"
}

input {
  kube_config = "${local.common.kube_config}"
}
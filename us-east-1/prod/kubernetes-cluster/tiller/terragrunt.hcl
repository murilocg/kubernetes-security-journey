include {
  path = find_in_parent_folders()
}

locals {
  config = yamldecode(file(find_in_parent_folders("config.yaml")))
}

terraform {
  after_hook "gen_cert" {
    commands = ["apply"]
    execute = ["./scripts/gencerts.sh", "${local.config.tiller.helm_home}"]
  }
}

dependency "cluster" {
  config_path = "${get_terragrunt_dir()}/../cluster"
  skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  kube_config = "${local.config.cluster.kube_config}"
}
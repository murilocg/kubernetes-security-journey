
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

include {
  path = find_in_parent_folders()
}

dependency "cluster" {
  config_path = "${get_terragrunt_dir()}/../cluster"
  skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan"]
}

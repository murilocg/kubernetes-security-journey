
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

include {
  path = find_in_parent_folders()
}

dependency "cluster" {
  config_path = "${get_terragrunt_dir()}/../cluster"
}

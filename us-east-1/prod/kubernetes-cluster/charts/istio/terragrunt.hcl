
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

include {
  path = find_in_parent_folders()
}

dependency "tiller" {
  config_path = "${get_terragrunt_dir()}/../../tiller"
}

inputs = {
    public_zone_cert = "${local.common_vars.public_zone_cert}"
    public_zone_id = "${local.common_vars.public_zone_id}"
}
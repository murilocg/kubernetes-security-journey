

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

include {
  path = find_in_parent_folders()
}

dependency "tiller" {
  config_path = "${get_terragrunt_dir()}/../../tiller"
  skip_outputs = true
}

inputs = {
  public_zone_cert = "${local.common_vars.public_zone_cert}"
  dns_name = "kong.${local.common_vars.public_zone_name}"
  kong_image_repository = "${local.common_vars.kong_image_repository}"
  kong_image_tag        = "${local.common_vars.kong_image_tag}"
}

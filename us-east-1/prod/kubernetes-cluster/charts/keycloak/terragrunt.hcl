

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
  dns_name = "idp.${local.common_vars.public_zone_name}"
  keycloak_image_repository = "${local.common_vars.keycloak_image_repository}"
  keycloak_image_tag        = "${local.common_vars.keycloak_image_tag}"
}

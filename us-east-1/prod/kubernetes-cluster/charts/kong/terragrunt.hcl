

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
  kong_image_repository = "docker.io/leogsilva/kong"
  kong_image_tag        = "v2"
  helm_home = "${local.common_vars.config_path}/helm"
  kube_config = "${local.common_vars.config_path}/kube/config"
}

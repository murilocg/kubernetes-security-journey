

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

include {
  path = find_in_parent_folders()
}

dependency "tiller" {
  config_path = "${get_terragrunt_dir()}/../../tiller"
  skip_outputs = true
}

inputs = {
  public_zone_cert = "${local.common.public_zone_cert}"
  dns_name = "kong.${local.common.public_zone_name}"
  helm_home = "${local.common.helm_home}"
  kube_config = "${local.common.kube_config}"
  kong_image_repository = "docker.io/leogsilva/kong"
  kong_image_tag        = "v2"
}

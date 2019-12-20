

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
  dns_name = "idp.${local.common.public_zone_name}"
  keycloak_image_repository = "docker.io/jboss/keycloak"
  keycloak_image_tag        = "7.0.0"
  helm_home = "${local.common.helm_home}"
  kube_config = "${local.common.kube_config}"
}

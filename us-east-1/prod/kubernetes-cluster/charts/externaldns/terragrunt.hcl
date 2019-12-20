

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
  namespace = "kube-system"
  public_zone_id = "${local.common.public_zone_id}"
  public_zone_name   = "${local.common.public_zone_name}"
  helm_home = "${local.common.helm_home}"
  kube_config = "${local.common.kube_config}"
}


include {
  path = find_in_parent_folders()
}

locals {
  path = "${find_in_parent_folders()}/../config/${get_env("ENVIRONMENT", "none")}"
  common = yamldecode(file("${local.path}/common.yaml"))
  cluster = yamldecode(file("${local.path}/cluster.yaml"))
}

dependency "tiller" {
  config_path = "${get_terragrunt_dir()}/../../tiller"
  skip_outputs = true
}

inputs = {
  namespace = "kube-system"
  public_zone_id = "${local.common.zone.id}"
  public_zone_name   = "${local.common.zone.name}"
  helm_home = "${local.common.tiller.helmHome}"
  kube_config = "${local.cluster.kubeConfig}"
}

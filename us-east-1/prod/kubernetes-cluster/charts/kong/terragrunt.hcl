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
  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  public_zone_cert = "${local.common.zone.cert}"
  dns_name = "kong.${local.common.zone.name}"
  helm_home = "${local.common.tiller.helmHome}"
  kube_config = "${local.cluster.kubeConfig}"
  kong_image_repository = "docker.io/leogsilva/kong"
  kong_image_tag        = "v2"
}

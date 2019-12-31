
include {
  path = find_in_parent_folders()
}

locals {
  path = "${find_in_parent_folders()}/../config/${get_env("ENVIRONMENT", "none")}"
  common = yamldecode(file("${local.path}/common.yaml"))
  cluster = yamldecode(file("${local.path}/cluster.yaml"))
}

terraform {

  before_hook "before_apply" {
    commands = ["apply"]
    execute = ["kubectl","--kubeconfig=${trimspace(abspath("${local.common.kube_config}"))}","apply","-f","https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml","--validate=false"]
    run_on_error = false
  }
  after_hook "after_apply" {
    commands = ["apply"]
    execute = ["kubectl","--kubeconfig=${trimspace(abspath("${local.common.kube_config}"))}","apply","-f","clusterissuer-staging.yaml"]
    run_on_error = false
  }
  after_hook "after_apply" {
    commands = ["apply"]
    execute = ["kubectl","--kubeconfig=${trimspace(abspath("${local.common.kube_config}"))}","apply","-f","clusterissuer-prod.yaml"]
    run_on_error = false
  }

}

dependency "tiller" {
  config_path = "${get_terragrunt_dir()}/../../tiller"
  skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  namespace = "kube-system"
  public_zone_id = "${local.common.zone.id}"
  public_zone_name   = "${local.common.zone.name}"
  helm_home = "${local.common.helmHome}"
  kube_config = "${local.common.kubeConfig}"
}

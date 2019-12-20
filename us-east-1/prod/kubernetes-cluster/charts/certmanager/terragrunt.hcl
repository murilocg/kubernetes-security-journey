

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
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

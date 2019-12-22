terraform {
  backend "s3" {
  }
}

provider "kubernetes" {
  config_path    = abspath("${var.kube_config}")
}

provider "helm" {
  version        = "~> 0.9"
  install_tiller = false
  home = "${var.helm_home}"
  init_helm_home = true
  namespace = "tiller"

  kubernetes {
    config_path = abspath("${var.kube_config}")
  }
}

data "helm_repository" "jetstack" {
    name = "jetstack"
    url  = "https://charts.jetstack.io"
}

resource "helm_release" "certmanager" {
    name       = "jetstack"
    repository = "${data.helm_repository.jetstack.metadata.0.name}"
    chart      = "jetstack/cert-manager"
    namespace  = "${var.namespace}" 
}

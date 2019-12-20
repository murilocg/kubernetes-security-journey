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

data "helm_repository" "stable" {
    name = "stable"
    url  = "https://kubernetes-charts.storage.googleapis.com/"
}

resource "helm_release" "external-dns" {
    name       = "externaldns"
    repository = "${data.helm_repository.stable.metadata.0.name}"
    chart      = "stable/external-dns"
    namespace  = "${var.namespace}"

    values = [
      templatefile("values.yaml",{ public_zone_id = "${var.public_zone_id}", public_zone_name = "${var.public_zone_name}" })
    ]  
}

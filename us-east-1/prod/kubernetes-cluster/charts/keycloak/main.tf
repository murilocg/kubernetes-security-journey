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

resource "kubernetes_namespace" "idp" {
  metadata {
    name = "idp"
  }
}

data "helm_repository" "codecentric" {
    name = "codecentric"
    url  = "https://codecentric.github.io/helm-charts"
}

resource "helm_release" "keycloak" {
    name       = "keycloak"
    repository = "${data.helm_repository.codecentric.metadata.0.name}"
    chart      = "codecentric/keycloak"
    namespace  = "${kubernetes_namespace.idp.metadata.0.name}"


    values = [
      templatefile("values.yaml",{ keycloak_image_repository = "${var.keycloak_image_repository}" , keycloak_image_tag = "${var.keycloak_image_tag}", dns_name = "${var.dns_name}" , public_zone_cert = "${var.public_zone_cert}" })
    ]  
}

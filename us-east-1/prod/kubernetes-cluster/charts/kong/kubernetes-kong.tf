terraform {
  backend "s3" {
  }
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CONFIGURE OUR KUBERNETES CONNECTIONS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

provider "kubernetes" {
  config_path    = abspath("${var.kube_config}")
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CONFIGURE OUR HELM PROVIDER 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
provider "helm" {
  version        = "~> 0.9"
  install_tiller = false
  home = "${var.helm_home}"
  # client_certificate     = file("../../kubernetes-tiller/.secret/helm_client_tls_public_cert_pem.pem")
  # client_key             = file("../../kubernetes-tiller/.secret/helm_client_tls_private_key_pem.pem")
  # ca_certificate = file("../../kubernetes-tiller/.secret/helm_client_tls_ca_cert_pem.pem")
  namespace = "tiller"

  kubernetes {
    config_path = abspath("${var.kube_config}")
  }
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE THE NAMESPACE WITH RBAC ROLES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
resource "kubernetes_service" "kong-service" {
  metadata {
    name = "kong-proxy-service"
    namespace = "${kubernetes_namespace.kong.metadata.0.name}"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-ssl-cert" = "${var.public_zone_cert}"
      "service.beta.kubernetes.io/aws-load-balancer-backend-protocol" =  "http"
      "service.beta.kubernetes.io/aws-load-balancer-ssl-ports" = "443"
      "service.beta.kubernetes.io/aws-load-balancer-connection-draining-enabled" = "true"
      "service.beta.kubernetes.io/aws-load-balancer-connection-draining-timeout" = "60"
      "external-dns.alpha.kubernetes.io/hostname" = "${var.dns_name}"
    }

  }
  spec {
    selector = {
      app="kong"
      component="app",
      release= "${helm_release.kong.name}"
    }
    port {
      name        = "http"
      port        = 80
      target_port = 8000
    }
    port {
      name        = "https"
      port        = 443
      target_port = 8000
    }
    type = "LoadBalancer"
  }
}


resource "kubernetes_namespace" "kong" {
  metadata {
    name = "kong"
    labels = {
      istio-injection = "enabled"
    }
  }

}

data "helm_repository" "stable" {
    name = "stable"
    url  = "https://kubernetes-charts.storage.googleapis.com/"
}

resource "helm_release" "kong" {
    name       = "kong"
    repository = "${data.helm_repository.stable.metadata.0.name}"
    chart      = "stable/kong"
    namespace  = "${kubernetes_namespace.kong.metadata.0.name}"

    values = [
      templatefile("values.yaml",{ kong_image_repository = "${var.kong_image_repository}" , kong_image_tag = "${var.kong_image_tag}", dns_name = "${var.dns_name}" , public_zone_cert = "${var.public_zone_cert}" })
    ]  
}

terraform {
  backend "s3" {
  }
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CONFIGURE OUR KUBERNETES CONNECTIONS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

provider "kubernetes" {
  config_path    = abspath("../../kubernetes-cluster/.kube")
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CONFIGURE OUR HELM PROVIDER 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
provider "helm" {
  version        = "~> 0.9"
  install_tiller = false
  client_certificate     = file("../../kubernetes-tiller/.secret/helm_client_tls_public_cert_pem.pem")
  client_key             = file("../../kubernetes-tiller/.secret/helm_client_tls_private_key_pem.pem")
  ca_certificate = file("../../kubernetes-tiller/.secret/helm_client_tls_ca_cert_pem.pem")
  namespace = "tiller"

  kubernetes {
    config_path = abspath("../../kubernetes-cluster/.kube")
  }
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE THE NAMESPACE WITH RBAC ROLES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

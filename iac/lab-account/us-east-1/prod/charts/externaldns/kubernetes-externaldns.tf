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

data "helm_repository" "stable" {
    name = "stable"
    url  = "https://kubernetes-charts.storage.googleapis.com/"
}

resource "helm_release" "external-dns" {
    name       = "externaldns"
    repository = "${data.helm_repository.stable.metadata.0.name}"
    chart      = "stable/external-dns"
    namespace  = "${var.namespace}"

    # values = [
    #     "${file("values.yaml")}"
    # ]  
    values = [
      templatefile("values.yaml",{ public_zone_id = "${var.public_zone_id}", public_zone_name = "${var.public_zone_name}" })
    ]  
}

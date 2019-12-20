terraform {
  backend "s3" {
  }
}

data "template_file" "dns-clusterissuer-template" {
  template = "${file("${path.module}/templates/dns-clusterissuer.yaml.tmpl")}"
  vars = {
    public_zone_id = "${var.public_zone_id}"
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

resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"
    labels = {
      istio-injection =  "disabled"
    }
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "null_resource" "crds" {
  provisioner "local-exec" {
    environment = {
      KUBECONFIG = abspath("${var.kube_config}")
    }
    command = "kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml"
  }
}

resource "null_resource" "dns-clusterissuer" {
  triggers = {
      test = "${data.template_file.dns-clusterissuer-template.rendered}"
  }  
  provisioner "local-exec" {
    environment = {
      KUBECONFIG = abspath("${var.kube_config}")
    }
    command = "${format("kubectl apply -f - <<EOF \n%s\nEOF", data.template_file.dns-clusterissuer-template.rendered)}"
  }
  depends_on = ["helm_release.istio-1-3"]
}

resource "helm_release" "istio-1-3-init" {
    name       = "istio-init"
    chart      = "./helm/istio-init"
    namespace  = "${kubernetes_namespace.istio-system.metadata.0.name}"
    depends_on = ["kubernetes_namespace.istio-system"]
}

resource "helm_release" "istio-1-3" {
    name       = "istio"
    chart      = "./helm/istio"
    namespace  = "${kubernetes_namespace.istio-system.metadata.0.name}"
    depends_on = ["helm_release.istio-1-3-init"]
    recreate_pods = true
    force_update  = true

    values = [
      templatefile("values.yaml",{ public_zone_cert = "${var.public_zone_cert}" })
    ]  

}
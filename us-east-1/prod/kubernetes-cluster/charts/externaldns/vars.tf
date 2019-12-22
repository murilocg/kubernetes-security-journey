
variable "public_zone_id" {
    type = string
    description = "ID of public domain certificate"
}

variable "namespace" {
    type = string
    description = "Kubernetes namespace for externaldns installation"
}

variable "public_zone_name" {
    type = string
    description = "Name of the public hosted zone"
}

variable "helm_home" {
  type = string
}

variable "kube_config" {
  type = string
}

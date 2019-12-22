
variable "dns_name" {
    type = string
    description = "External name for Kong endpoint"
}

variable "public_zone_cert" {
    type = string
    description = "Arn of public domain certificate"
}

variable "keycloak_image_repository" {
    type = string
    default = "docker.io/leogsilva/kong"
    description = "keycloak image repository"
}

variable "keycloak_image_tag" {
    type = string
    default = "7.0.0"
    description = "keycloak image tag"
}

variable "helm_home" {
  type = string
}

variable "kube_config" {
  type = string
}



variable "dns_name" {
    type = string
    description = "External name for Kong endpoint"
}

variable "public_zone_cert" {
    type = string
    description = "Arn of public domain certificate"
}

variable "kong_image_repository" {
    type = string
    default = "docker.io/leogsilva/kong"
    description = "Customized kong image containing kong-oidc from https://github.com/nokia/kong-oidc"
}

variable "kong_image_tag" {
    type = string
    default = "v2"
    description = "Customized kong image containing kong-oidc from https://github.com/nokia/kong-oidc"
}

variable "helm_home" {
  type = string
}

variable "kube_config" {
  type = string
}



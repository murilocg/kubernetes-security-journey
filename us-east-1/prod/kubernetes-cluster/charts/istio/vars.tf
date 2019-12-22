
variable "public_zone_cert" {
    type = string
    description = "Arn of public domain certificate"
}

variable "public_zone_id" {
    type = string
    description = "Id for public zone on aws route53"
}

variable "helm_home" {
  type = string
}

variable "kube_config" {
  type = string
}
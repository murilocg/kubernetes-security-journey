
variable "dns_name" {
    type = string
    description = "External name for Kong endpoint"
}

variable "public_zone_cert" {
    type = string
    description = "Arn of public domain certificate"
}

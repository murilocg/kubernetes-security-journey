variable "environment" {
  description = "Environment"
  type = string
}

variable "cluster_name" {
  description = "Cluster Name"
  type = string
}

variable "region" {
  description = "Region"
  type = string
}

variable "cidr" {
  description = "Cidr"
  type = string
}

variable "azs" {
    description = "AZS"
    type = list(string)
}

variable "private_subnets" {
  description = "Private Subnets"
  type = list(string)
}

variable "public_subnets" {
  description = "Public Subnets"
  type = list(string)
}
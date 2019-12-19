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

variable "kops_state_bucket" {
  description = "Kops State bucket"
  type = string
}

variable "ingress_ips" {
  description = "ingress Ips"
  type = list(string)
}

variable "vpc_id" {
  description = "VPC id"
  type = string
}
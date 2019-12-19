

variable "cluster_name" {
  type = "string"
  description = "Cluster name for kubernetes"
}

variable "bucket_name" {
  type = "string"
  description = "Name of kops state store bucket"
}

variable "vpc_filter" {
  type = "map"
  description = "filter for locating desired VPC"
}

variable "environment" {
  type = "string"
  description = "Name of the environment for this stack"
}

variable "tags" {
  type = "map"
  default = {
    Environment = "tutorial"
    Application = "kops"
  }
}

variable "ingress_ips" {
  type = "list"
  description = "List of ingress ips for cluster access"
}

variable "vpc_id" {
  type = "string"
  description = "Vpc id for this cluster"
}
provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source = "../../../../modules/kops-cluster"
  cluster_name = "${var.cluster_name}"
  environment = "${var.environment}"
  bucket_name = "${var.kops_state_bucket}"
  ingress_ips = "${var.ingress_ips}"
  vpc_id = "${var.vpc_id}"
  vpc_filter = {
    Environment = "${var.environment}"
    Application = "network"
    "kubernetes.io/cluster/${var.cluster_name}" = "${var.environment}"
  }
}

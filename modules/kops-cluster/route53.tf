
# Creates a route 53 zone for this cluster
resource "aws_route53_zone" "cluster" {
  name = "${var.cluster_name}"
  force_destroy = true
  vpc {
    vpc_id = "${var.vpc_id}"
  }
}

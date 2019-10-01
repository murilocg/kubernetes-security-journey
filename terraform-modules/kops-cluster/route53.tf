
# Creates a route 53 zone for this cluster
resource "aws_route53_zone" "cluster" {
  name = "${var.cluster_name}"

  vpc {
    vpc_id = "${data.aws_vpc.cluster-vpc.id}"
  }
}


output "kops_s3_bucket_name" {
  value = "${aws_s3_bucket.kops_state.bucket}"
}
output "k8s_api_http_security_group_id" {
  value = "${aws_security_group.k8s_api_http.id}"
}
output "cluster_name" {
  value = "${var.cluster_name}"
}

output "dns_zone" {
  value = "${aws_route53_zone.cluster.zone_id}"
}


output "vpc_id" {
  value = "${var.vpc_id}"  
}
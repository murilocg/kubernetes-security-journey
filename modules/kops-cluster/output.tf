output "k8s_api_http_security_group_id" {
  value = "${aws_security_group.k8s_api_http.id}"
}

output "dns_zone" {
  value = "${aws_route53_zone.cluster.zone_id}"
}
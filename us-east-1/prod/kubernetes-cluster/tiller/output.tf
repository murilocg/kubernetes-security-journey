output "tiller_namespace" {
  description = "The name of the namespace that houses Tiller."
  value       = module.tiller_namespace.name
}


output "key" {
  description = "The private key of the TLS certificate key pair to use for the helm client."
  sensitive   = true
  value       = module.helm_client_tls_certs.tls_certificate_key_pair_private_key_pem
}

output "cert" {
  description = "The public certificate of the TLS certificate key pair to use for the helm client."
  sensitive   = true
  value       = module.helm_client_tls_certs.tls_certificate_key_pair_certificate_pem
}

output "ca" {
  description = "The CA certificate of the TLS certificate key pair to use for the helm client."
  sensitive   = true
  value       = module.helm_client_tls_certs.ca_tls_certificate_key_pair_certificate_pem
}

#!/bin/bash


TF_OUTPUT="$(yes | terragrunt output-all -json | jq -s add )"
CERT_NAME="$(echo ${TF_OUTPUT} | jq -r .$1.value)"

certs="helm_client_tls_private_key_pem helm_client_tls_public_cert_pem helm_client_tls_ca_cert_pem"
mkdir -p ./.secret
for $i in $certs; do;
  echo -e "$i" > ./.secret/$i.pem
done

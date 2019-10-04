#!/bin/bash

set +x

if [[ ! -f .kube ]]; then

  cd "$(dirname "$0")"

  TF_OUTPUT="$(yes | terragrunt output-all -json | jq -s add )"
  CLUSTER_NAME="$(echo ${TF_OUTPUT} | jq -r .cluster_name.value)"
  STATE="s3://$(echo ${TF_OUTPUT} | jq -r .kops_s3_bucket_name.value)"

  kops export kubecfg ${CLUSTER_NAME} --state ${STATE} --kubeconfig .kube 

fi

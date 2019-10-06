#!/bin/bash

set -x

cd "$(dirname "$0")"


TF_OUTPUT="$(yes | terragrunt output-all -json | jq -s add )"
CLUSTER_NAME="$(echo ${TF_OUTPUT} | jq -r .cluster_name.value)"
STATE="s3://$(echo ${TF_OUTPUT} | jq -r .kops_s3_bucket_name.value)"

# Removing old etcd backups
aws s3 rm ${STATE}/backups 

kops toolbox template --name $CLUSTER_NAME --values <( echo ${TF_OUTPUT}) --template cluster-definition.yaml --format-yaml > cluster.yaml

kops replace -f cluster.yaml --state ${STATE} --name ${CLUSTER_NAME} --force

kops create secret --name ${CLUSTER_NAME} --state ${STATE} sshpublickey admin -i ~/.ssh/id_rsa.pub

kops update cluster --out=. --target=terraform --state ${STATE} --name ${CLUSTER_NAME}

rm -fr versions.tf || true
echo "yes" | terraform 0.12upgrade .

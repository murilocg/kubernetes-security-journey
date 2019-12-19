#!/bin/bash

set -x

TF_OUTPUT="$(yes | terragrunt output-all -json | jq -s add )"
CLUSTER_NAME="$1"
STATE="s3://$2"
PUBLIC_ZONE_ID="$3"
ENVIRONMENT="$4"

yell() { echo "$0: $*" >&2; }

#Check if the output is a valid json
if jq -e . >/dev/null 2>&1 <<<"$json_string"; then
  # Removing old etcd backups
  aws s3 rm ${STATE}/backups || true
  aws s3 rm ${STATE}/${CLUSTER_NAME}/cluster.spec || true
  rm -fr kubernetes.tf || true
  rm -fr data/* || true
  kops toolbox template --name $CLUSTER_NAME \
  --fail-on-missing=false \
  --values <( echo ${TF_OUTPUT}) \
  --set-string cluster_name=${CLUSTER_NAME} \
  --set-string kops_s3_bucket_name=${STATE} \
  --set-string public_zone_id=${PUBLIC_ZONE_ID} \
  --set-string env=${ENVIRONMENT}
  --template cluster-definition.yaml --format-yaml > cluster.yaml
else
  exit 0
fi

#!/bin/bash

set -x

TF_OUTPUT="$(yes | terragrunt output-all -json | jq -s add )"
CLUSTER_NAME="$1"
STATE="s3://$2"
PUBLIC_ZONE_ID="$3"
ENVIRONMENT="$4"
EMPTY_JSON="$(jq --arg a $TF_OUTPUT --arg b '{}' -n '$a != $b')"
VALID_JSON="$(jq -e . >/dev/null 2>&1 <<<\"$json_string\")"

#Check if the output is a valid json
if (${VALID_JSON}) && (${EMPTY_JSON}) then
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
  --set-string env=${ENVIRONMENT} \
  --template cluster-definition.yaml --format-yaml > cluster.yaml

  kops replace -f cluster.yaml --state ${STATE} --name ${CLUSTER_NAME} --force
  kops create secret --name ${CLUSTER_NAME} --state ${STATE} sshpublickey admin -i ~/.ssh/id_rsa.pub
  kops update cluster --out=. --target=terraform --state ${STATE} --name ${CLUSTER_NAME}
else
  exit 0
fi

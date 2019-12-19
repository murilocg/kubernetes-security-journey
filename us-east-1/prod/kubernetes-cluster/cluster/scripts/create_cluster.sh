#!/bin/bash

set -x

CLUSTER_NAME="$1"
STATE="s3://$2"

yell() { echo "$0: $*" >&2; }

if test -f "../cluster.yaml"; then
  kops replace -f cluster.yaml --state ${STATE} --name ${CLUSTER_NAME} --force
  kops create secret --name ${CLUSTER_NAME} --state ${STATE} sshpublickey admin -i ~/.ssh/id_rsa.pub
  kops update cluster --out=. --target=terraform --state ${STATE} --name ${CLUSTER_NAME}
  rm -fr versions.tf || true
  echo "yes" | terraform 0.12upgrade .
else
  exit 1
fi

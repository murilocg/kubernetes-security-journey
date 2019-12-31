#!/bin/bash

set +x

ENVIRONMENT="$1"

cp config/${ENVIRONMENT}/common.yaml kubernetes-cluster/common.yaml
cp config/${ENVIRONMENT}/cluster.yaml kubernetes-cluster/cluster.yaml
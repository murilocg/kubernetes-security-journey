#!/bin/bash

set -x

ENVIRONMENT="$1"
REGION="$2"
FOLDER="./${REGION}/${ENVIRONMENT}"

cp -r ./modules/kubernetes-cluster ${FOLDER}
cd ${FOLDER}


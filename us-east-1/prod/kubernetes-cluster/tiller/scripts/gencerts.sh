#!/bin/bash


TF_OUTPUT="$(yes | terragrunt output-all -json | jq -s add )"
HELM_HOME=$1
certs="key cert ca"
mkdir -p ${HELM_HOME}
for i in `echo $certs`; do
  cert="$(echo ${TF_OUTPUT} | jq -r .$i.value)"
  echo -e "$cert" > ${HELM_HOME}/$i.pem
done

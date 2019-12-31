#!/bin/bash

set -x

CLUSTER_NAME="$1"
STATE="s3://$2"
KUBE_CONFIG="$3"

kops export kubecfg ${CLUSTER_NAME} --state ${STATE} --kubeconfig ${KUBE_CONFIG}

SERVER=$(kubectl config view --kubeconfig ${KUBE_CONFIG} -o jsonpath='{..clusters[0].cluster.server}')

# Path to your hosts file
hostsFile="/etc/hosts"

# Default IP address for host
ip="$2"

# Hostname to add/remove.
hostname="$3"

yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }

remove() {
    if [ -n "$(grep -p "[[:space:]]$hostname" /etc/hosts)" ]; then
        echo "$hostname found in $hostsFile. Removing now...";
        try sudo sed -ie "/[[:space:]]$hostname/d" "$hostsFile";
    else
        yell "$hostname was not found in $hostsFile";
    fi
}

add() {
    if [ -n "$(grep -p "[[:space:]]$hostname" /etc/hosts)" ]; then
        yell "$hostname, already exists: $(grep $hostname $hostsFile)";
    else
        echo "Adding $hostname to $hostsFile...";
        try printf "%s\t%s\n" "$ip" "$hostname" | sudo tee -a "$hostsFile" > /dev/null;

        if [ -n "$(grep $hostname /etc/hosts)" ]; then
            echo "$hostname was added succesfully:";
            echo "$(grep $hostname /etc/hosts)";
        else
            die "Failed to add $hostname";
        fi
    fi
}

for i in `dig +short $(basename ${SERVER})`; do 
  hostname="api.${CLUSTER_NAME}"
  ip=$i
  remove
  add 
done

# Update .kube configuration
kubectl config set-cluster ${CLUSTER_NAME} --server=https://${CLUSTER_NAME} --kubeconfig ${KUBE_CONFIG}

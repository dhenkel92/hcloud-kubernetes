#! /bin/bash

set -ex

# todo: change to proper domain
export KUBERNETES_PUBLIC_ADDRESS="10.0.1.50"
export EXTERNAL_DNS_NAME="hetzner.k8s"

read -p "Do you wish to regenerate ca? (y/n)" yn
case $yn in
    [Yy]* ) ./generate-ca.sh;;
esac

./generate-client.sh admin admin system:masters $KUBERNETES_PUBLIC_ADDRESS
./generate-client.sh kubelet system:node system:nodes $KUBERNETES_PUBLIC_ADDRESS
./generate-client.sh kube-controller-manager system:kube-controller-manager system:kube-controller-manager 127.0.0.1
./generate-client.sh kube-proxy system:kube-proxy system:node-proxier $KUBERNETES_PUBLIC_ADDRESS
./generate-client.sh kube-scheduler system:kube-scheduler system:kube-scheduler 127.0.0.1
./generate-client.sh service-account service-accounts Kubernetes $KUBERNETES_PUBLIC_ADDRESS
./generate-client.sh calico calico-node calico-node $KUBERNETES_PUBLIC_ADDRESS
./generate-client.sh kubernetes kubernetes Kubernetes $KUBERNETES_PUBLIC_ADDRESS

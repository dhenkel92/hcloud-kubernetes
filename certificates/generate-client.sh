#! /bin/bash

set -ex

NAME=$1
CN=$2
O=$3

mkdir -p ./$NAME
cd ./$NAME

cat <<EOF > $NAME-csr.json 
{
  "CN": "$CN",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "hosts": [
        "10.0.1.50",
        "10.0.1.51",
        "10.0.1.52",
        "10.0.1.53",

        "worker-0",
        "worker-1",
        "worker-2",
        "worker-3",
        "worker-4",
        "10.0.2.110",
        "10.0.2.111",
        "10.0.2.112",
        "10.0.2.113",
        "10.0.2.114",

        "10.0.3.1",
        "10.0.2.1",
        "10.0.1.1",
        
        "$EXTERNAL_DNS_NAME",
        "localhost",
        "127.0.0.1",
        "10.32.0.1",
        "10.240.0.10",
        "10.240.0.11",
        "10.240.0.12"
    ],
  "names": [
    {
      "C": "DE",
      "L": "Munich",
      "ST": "Baveria",
      "O": "$O",
      "OU": "Kubernetes The Hard Way"
    }
  ]
}
EOF

cfssl gencert \
  -ca=../ca/ca.pem \
  -ca-key=../ca/ca-key.pem \
  -config=../ca/ca-config.json \
  -profile=kubernetes \
  ./$NAME-csr.json | cfssljson -bare $NAME


# Generate kubeconfig
kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=../ca/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=$NAME.kubeconfig

kubectl config set-credentials $CN \
    --client-certificate=$NAME.pem \
    --client-key=$NAME-key.pem \
    --embed-certs=true \
    --kubeconfig=$NAME.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=$CN \
    --kubeconfig=$NAME.kubeconfig

kubectl config use-context default --kubeconfig=$NAME.kubeconfig
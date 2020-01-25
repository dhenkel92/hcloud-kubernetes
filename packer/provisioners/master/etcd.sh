#! /bin/bash

set -ex

echo "Using ETCD Version: $ETCD_VERSION"

# General setup
apt-get update
apt-get dist-upgrade -y

# Setup etcd
curl -L https://github.com/etcd-io/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz -o /tmp/etcd.tar.gz
mkdir -p /tmp/etcd
tar xzvf /tmp/etcd.tar.gz -C /tmp/etcd --strip-components=1

mv /tmp/etcd/etcd /usr/bin
mv /tmp/etcd/etcdctl /usr/bin

cat <<EOF > /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/bin/etcd --name ETCD_NAME \
  --cert-file=/var/lib/kubernetes/kubernetes.pem \
  --key-file=/var/lib/kubernetes/kubernetes-key.pem \
  --peer-cert-file=/var/lib/kubernetes/kubernetes.pem \
  --peer-key-file=/var/lib/kubernetes/kubernetes-key.pem \
  --trusted-ca-file=/var/lib/kubernetes/ca.pem \
  --peer-trusted-ca-file=/var/lib/kubernetes/ca.pem \
  --initial-advertise-peer-urls https://INTERNAL_IP:2380 \
  --listen-peer-urls https://INTERNAL_IP:2380 \
  --listen-client-urls https://INTERNAL_IP:2379,https://127.0.0.1:2379 \
  --advertise-client-urls https://INTERNAL_IP:2379 \
  --initial-cluster-token etcd-cluster-0 \
  --initial-cluster master-0=https://10.0.1.50:2380,master-1=https://10.0.1.51:2380,master-2=https://10.0.1.52:2380 \
  --initial-cluster-state new \
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "ETCDCTL_ENDPOINTS=https://127.0.0.1:2379" >> /etc/environment
echo "ETCDCTL_CA_FILE=/var/lib/kubernetes/ca.pem" >> /etc/environment

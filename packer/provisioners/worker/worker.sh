#! /bin/bash

set -ex

echo "Using K8s Version: $K8S_VERSION"

# General setup
apt-get update
apt-get dist-upgrade -y
apt-get install -y socat conntrack ipset tcpdump

# Setup executables
wget https://storage.googleapis.com/kubernetes-release/release/$K8S_VERSION/bin/linux/amd64/kubelet -O /usr/bin/kubelet
wget https://storage.googleapis.com/kubernetes-release/release/$K8S_VERSION/bin/linux/amd64/kube-proxy -O /usr/bin/kube-proxy
wget https://storage.googleapis.com/kubernetes-release/release/$K8S_VERSION/bin/linux/amd64/kubectl -O /usr/bin/kubectl

chmod +x /usr/bin/kube*

# Install kubelet
cat <<EOF > /var/lib/kubernetes/kubelet-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/var/lib/kubernetes/ca.pem"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  - "192.168.0.10"
resolvConf: "/run/systemd/resolve/resolv.conf"
podCIDR: "192.168.0.0/24"
runtimeRequestTimeout: "15m"
tlsCertFile: "/var/lib/kubernetes/kubelet.pem"
tlsPrivateKeyFile: "/var/lib/kubernetes/kubelet-key.pem"
EOF

cat <<EOF > /etc/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]

ExecStart=/usr/bin/kubelet \
    --container-runtime=docker \
    --image-pull-progress-deadline=2m \
    --config=/var/lib/kubernetes/kubelet-config.yaml \
    --kubeconfig=/var/lib/kubernetes/kubelet.kubeconfig \
    --network-plugin=cni \
    --cni-conf-dir=/etc/cni/net.d \
    --cni-bin-dir=/opt/cni/bin \
    --register-node=true \
    --cloud-provider= \
    --v=2

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

[Service]
EOF

# Install Kube proxy
cat <<EOF > /etc/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/bin/kube-proxy \
  --kubeconfig=/var/lib/kubernetes/kube-proxy.kubeconfig \
  --cluster-cidr=192.168.0.0/24 \
  --proxy-mode=iptables \
  --v=2

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# todo: Take care of shutdown later
# # Install shutdown script
# cat <<'EOF' > /usr/bin/shutdown-k8s.sh
# #! /bin/bash

# set -ex

# host=$(hostname)
# echo "Remove Host: $host"
# kubectl drain $host

# echo "sleep until all pods got evicted"
# sleep 60

# kubectl delete node $host
# calicoctl delete node $host
# EOF
# chmod +x /usr/bin/shutdown-k8s.sh

# cat <<EOF > /etc/systemd/system/shutdown-k8s.service
# [Unit]
# Description="Service to properly handle node shutdown"
# Requires=network.target
# DefaultDependencies=no
# Before=shutdown.target reboot.target

# [Service]
# ExecStart=/bin/true
# Type=oneshot
# RemainAfterExit=true
# ExecStop=/usr/bin/shutdown-k8s.sh

# [Install]
# WantedBy=multi-user.target
# EOF

#! /bin/bash

set -ex

# https://github.com/projectcalico/calico/issues/2322
update-alternatives --set iptables /usr/sbin/iptables-legacy

# General stuff
sudo mkdir -p \
  /etc/calico \
  /etc/cni/net.d \
  /opt/cni/bin \
  /var/lib/kubernetes \
  /var/run/kubernetes

# Install Loopback
wget https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz -O /tmp/cni-plugins.tgz
tar -xvf /tmp/cni-plugins.tgz -C /opt/cni/bin/

cat >/etc/cni/net.d/99-loopback.conf <<EOF
{
    "cniVersion": "0.3.1",
    "type": "loopback"
}

EOF

# Install calico
wget https://github.com/projectcalico/calicoctl/releases/download/$CALICO_VERSION/calicoctl -O /usr/bin/calicoctl
chmod +x /usr/bin/calicoctl

wget -N https://github.com/projectcalico/cni-plugin/releases/download/$CALICO_VERSION/calico-amd64 -O /opt/cni/bin/calico
wget -N https://github.com/projectcalico/cni-plugin/releases/download/$CALICO_VERSION/calico-ipam-amd64 -O /opt/cni/bin/calico-ipam
chmod +x /opt/cni/bin/calico*

# Configure calico
cat <<EOF > /etc/calico/calico.env
ETCD_ENDPOINTS=https://10.0.1.50:2379,https://10.0.1.51:2379,https://10.0.1.52:2379
ETCD_CA_CERT_FILE="/var/lib/kubernetes/ca.pem"
ETCD_CERT_FILE="/var/lib/kubernetes/kubernetes.pem"
ETCD_KEY_FILE="/var/lib/kubernetes/kubernetes-key.pem"
CALICO_NODENAME=""
CALICO_NO_DEFAULT_POOLS=""
CALICO_IP=""
CALICO_IP6=""
CALICO_AS=""
CALICO_NETWORKING_BACKEND=bird
EOF

cat <<EOF > /etc/systemd/system/calico.service
[Unit]
Description=calico-node
After=docker.service
Requires=docker.service

[Service]
User=root
EnvironmentFile=/etc/calico/calico.env
PermissionsStartOnly=true
ExecStartPre=-/usr/bin/docker rm -f calico-node
ExecStart=/usr/bin/docker run --net=host --privileged \
 --name=calico-node \
 -e NODENAME=\${CALICO_NODENAME} \
 -e IP=\${CALICO_IP} \
 -e CALICO_NETWORKING_BACKEND=\${CALICO_NETWORKING_BACKEND} \
 -e AS=\${CALICO_AS} \
 -e CALICO_IPV4POOL_CIDR=192.168.0.0/24 \
 -e CALICO_IPV4POOL_IPIP=Always \
 -e CALICO_IPV4POOL_NAT_OUTGOING=true \
 -e CALICO_LIBNETWORK_ENABLED=true \
 -e IP_AUTODETECTION_METHOD=interface=ens10 \
 -e NO_DEFAULT_POOLS=\${CALICO_NO_DEFAULT_POOLS} \
 -e FELIX_DEFAULTENDPOINTTOHOSTACTION=ACCEPT \
 -e ETCD_ENDPOINTS=\${ETCD_ENDPOINTS} \
 -e ETCD_CA_CERT_FILE=\${ETCD_CA_CERT_FILE} \
 -e ETCD_CERT_FILE=\${ETCD_CERT_FILE} \
 -e ETCD_KEY_FILE=\${ETCD_KEY_FILE} \
 -v /lib/modules:/lib/modules \
 -v /run/docker/plugins:/run/docker/plugins \
 -v /var/run/calico:/var/run/calico \
 -v /var/log/calico:/var/log/calico \
 -v /var/lib/calico:/var/lib/calico \
 -v /var/lib/kubernetes:/var/lib/kubernetes \
 calico/node:$CALICO_VERSION

ExecStop=-/usr/bin/docker stop calico-node

Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF

cat >/etc/cni/net.d/10-calico.conf <<EOF
{
    "name": "calico-k8s-network",
    "cniVersion": "0.3.1",
    "type": "calico",
    "etcd_endpoints": "https://10.0.1.50:2379,https://10.0.1.51:2379,https://10.0.1.52:2379",
    "log_level": "info",
    "etcd_key_file": "/var/lib/kubernetes/kubernetes-key.pem",
    "etcd_cert_file": "/var/lib/kubernetes/kubernetes.pem",
    "etcd_ca_cert_file": "/var/lib/kubernetes/ca.pem",
    "log_level": "DEBUG",
    "ipam": {
        "type": "calico-ipam",
        "ipv4_pools": ["192.168.0.0/24"]
    },
    "container_settings": {
        "allow_ip_forwarding": true
    },
    "policy": {
        "type": "k8s"
    },
    "kubernetes": {
        "kubeconfig": "/var/lib/kubernetes/calico.kubeconfig"
    }
}
EOF

cat <<EOF > /etc/calico/calicoctl.cfg
apiVersion: projectcalico.org/v3
kind: CalicoAPIConfig
metadata:
spec:
  etcdEndpoints: https://10.0.1.50:2379,https://10.0.1.51:2379,https://10.0.1.52:2379
  etcdKeyFile: /var/lib/kubernetes/kubernetes-key.pem
  etcdCertFile: /var/lib/kubernetes/kubernetes.pem
  etcdCACertFile: /var/lib/kubernetes/ca.pem
EOF

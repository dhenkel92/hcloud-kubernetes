#! /bin/bash

set -x

# General setup
echo "10.0.2.110 worker-0" >> /etc/hosts
echo "10.0.2.111 worker-1" >> /etc/hosts
echo "10.0.2.112 worker-2" >> /etc/hosts
echo "10.0.2.113 worker-3" >> /etc/hosts
echo "10.0.2.114 worker-4" >> /etc/hosts
echo "10.0.2.115 worker-5" >> /etc/hosts
echo "10.0.2.116 worker-6" >> /etc/hosts
echo "10.0.2.117 worker-7" >> /etc/hosts
echo "10.0.2.118 worker-8" >> /etc/hosts
echo "10.0.2.119 worker-9" >> /etc/hosts

# Replace POD IP CIDR configuration
echo "CLUSTER_CIDR_RANGE=${pod_ip_cidr}" >> /var/lib/kubernetes/k8s.env
echo "K8S_DNS_IP=${dns_ip}" >> /var/lib/kubernetes/k8s.env

echo "CLUSTER_CIDR_RANGE=${pod_ip_cidr}" >> /etc/calico/calico.env

sed -i s,CLUSTER_CIDR_RANGE,${pod_ip_cidr},g /etc/cni/net.d/10-calico.conf

# start/enable services
sleep 15
systemctl daemon-reload

systemctl enable systemd-resolved
systemctl start systemd-resolved

sleep 5

systemctl enable calico
systemctl start calico

sleep 10

systemctl enable kubelet kube-proxy
systemctl start kubelet kube-proxy
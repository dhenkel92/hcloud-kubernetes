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

# start/enable services
sleep 15
systemctl daemon-reload

systemctl enable calico
systemctl start calico

sleep 10

systemctl enable kubelet kube-proxy
systemctl start kubelet kube-proxy
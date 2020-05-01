#! /bin/bash

set -x

# Enable firewall
# ufw enable

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

# Setup etcd service
sleep 10

ETCD_NAME=$(hostname -s)
INTERNAL_IP=$(ifconfig ens10 | grep 'inet ' | awk '{print $2}')

sed -i s/ETCD_NAME/$ETCD_NAME/g /etc/systemd/system/etcd.service
sed -i s/INTERNAL_IP/$INTERNAL_IP/g /etc/systemd/system/etcd.service

systemctl daemon-reload
systemctl enable etcd
systemctl start etcd

# Setup etcd service
sleep 30

INTERNAL_IP=$(ifconfig ens10 | grep 'inet ' | awk '{print $2}')
sed -i s/INTERNAL_IP/$INTERNAL_IP/g /etc/systemd/system/kube-apiserver.service
sed -i s/INTERNAL_IP/$INTERNAL_IP/g /etc/systemd/system/kube-controller-manager.service
sed -i s/INTERNAL_IP/$INTERNAL_IP/g /etc/systemd/system/kube-scheduler.service

systemctl daemon-reload
systemctl enable kube-apiserver kube-controller-manager kube-scheduler
systemctl start kube-apiserver kube-controller-manager kube-scheduler

# Waiting for apiserver to get ready
status=1
while [ $status -eq 1 ]; do
	echo "Apiserver not ready yet. Waiting..."
	sleep 10
	jaha=$(kubectl --kubeconfig /root/.kube/config get componentstatuses)
	status=$?
done

echo "Apiserver should be ready now! :)"

# Apply RBAC roles

# https://github.com/kubernetes/kops/issues/3551#issuecomment-345154859
kubectl --kubeconfig /root/.kube/config set subject clusterrolebinding system:node --group=system:nodes
# ApiServer to Kubelet permissions
kubectl --kubeconfig /root/.kube/config apply -f /rbac/kubelet-rbac.yaml

# Some calico permission
kubectl --kubeconfig /root/.kube/config create -n kube-system serviceaccount calico-kube-controllers | true
kubectl --kubeconfig /root/.kube/config apply -f https://docs.projectcalico.org/v3.11/manifests/rbac/rbac-etcd-calico.yaml
kubectl --kubeconfig /root/.kube/config set subject clusterrolebinding calico-node --group=calico-node

# Calico controller
cd /var/lib/kubernetes
kubectl --kubeconfig /root/.kube/config create -n kube-system secret generic calico-etcd-certs --from-file=./ca.pem --from-file=./kubernetes.pem --from-file=./kubernetes-key.pem | true
kubectl --kubeconfig /root/.kube/config apply -f /rbac/calico-controller.yaml

# Coredns
kubectl --kubeconfig /root/.kube/config apply -f /rbac/coredns.yaml

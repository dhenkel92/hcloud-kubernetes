# Hetzner Cloud Kubernetes Setup

This setup is inspired by [kubernetes the hard way](https://github.com/Praqma/LearnKubernetes/blob/master/kamran/Kubernetes-The-Hard-Way-on-BareMetal.md) and automatically creates a kubernets cluster with [Terraform](https://www.terraform.io/) and [Packer](https://www.packer.io/).
It will create a kubernetes cluster with three master and three worker nodes on the *Hetzner Cloud*.

## Stack
I've decided to use [calico](https://www.projectcalico.org/) as networking plugin, because we are using it in my current job and i wanted to get a deeper understanding of it.

* Kubernetes v1.18.2
* Etcd v3.4.7
* Calico v3.13.3

The versions can be adapted in `packer/vars/production.json`.

## How to setup cluster
```shell
export HCLOUD_TOKEN=<put_your_token_here>

cd certificates
./generat-all # answer with yes, to generate new ca file

cd ../packer
packer build -var-file=vars/production.json manifests/master.json
packer build -var-file=vars/production.json manifests/worker.json

cd ../terraform
terraform apply -var-file ./vars/k8s.tfvars
```
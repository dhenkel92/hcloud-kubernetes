# Hetzner Cloud Kubernetes Setup :)

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
provider "hcloud" {}

data "hcloud_image" "worker_image" {
  with_selector = "application=k8s_worker"
  most_recent   = true
}

module "worker_nodes" {
  source = "./vms"

  image      = data.hcloud_image.worker_image.id
  ssh_keys   = var.ssh_keys
  location   = var.location
  labels     = var.labels
  network_id = var.network_id

  name       = "worker"
  node_type  = var.node_type.worker
  node_count = var.node_count.worker
  ip_prefix  = var.ip_prefixes.worker

  user_data = templatefile("${path.module}/../../files/worker.sh", {
    pod_ip_cidr = var.pod_ip_cidr,
    dns_ip      = var.dns_ip,
  })
}

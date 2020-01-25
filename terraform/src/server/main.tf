data "hcloud_image" "master_image" {
  with_selector = "application=k8s_master"
  most_recent = true
}

data "hcloud_image" "worker_image" {
  with_selector = "application=k8s_worker"
  most_recent = true
}

module "master_nodes" {
    source = "./vms"
    
    image = data.hcloud_image.master_image.id
    ssh_keys = var.ssh_keys
    location = var.location
    labels = var.labels
    network_id = var.network_id

    name = "master"
    node_type = var.node_type.master
    node_count = var.node_count.master
    ip_prefix = var.ip_prefixes.master

    user_data = file("${path.module}/../../files/master.sh")
}

module "worker_nodes" {
    source = "./vms"

    image = data.hcloud_image.worker_image.id
    ssh_keys = var.ssh_keys
    location = var.location
    labels = var.labels
    network_id = var.network_id

    name = "worker"
    node_type = var.node_type.worker
    node_count = var.node_count.worker
    ip_prefix = var.ip_prefixes.worker

    user_data = file("${path.module}/../../files/worker.sh")
}
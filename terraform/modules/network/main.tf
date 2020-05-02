resource "hcloud_network" "net" {
    name = var.name
    ip_range = var.net_ip_range
    labels = var.labels
}

resource "hcloud_network_subnet" "master_node_subnet" {
    network_id = hcloud_network.net.id
    type = "server"
    network_zone = var.network_zone
    ip_range = var.subnet_ip_ranges.master_nodes
}

resource "hcloud_network_subnet" "worker_node_subnet" {
    network_id = hcloud_network.net.id
    type = "server"
    network_zone = var.network_zone
    ip_range = var.subnet_ip_ranges.worker_nodes
}
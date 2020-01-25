resource "hcloud_server" "nodes" {
    count = var.node_count
    name = "${var.name}-${count.index}"
    image = var.image
    server_type = var.node_type
    ssh_keys = var.ssh_keys
    location = var.location
    labels = var.labels
    user_data = var.user_data
}

resource "hcloud_server_network" "node_srvnetwork" {
    count = length(hcloud_server.nodes)
    server_id = hcloud_server.nodes[count.index].id
    network_id = var.network_id
    ip = "${var.ip_prefix}${count.index}"
}

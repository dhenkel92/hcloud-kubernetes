resource "hcloud_floating_ip" "ip" {
    count = var.fip_count
    type = "ipv4"
    home_location = var.location
    labels = var.labels
}

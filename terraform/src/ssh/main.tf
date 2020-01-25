resource "hcloud_ssh_key" "ssh_keys" {
    for_each = var.ssh_keys
    name = each.key
    public_key = each.value
}

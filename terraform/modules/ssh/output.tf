output "ssh_keys" {
  value = values(hcloud_ssh_key.ssh_keys).*.id
}

output "ips" {
  value = hcloud_floating_ip.ip.*.ip_address
}

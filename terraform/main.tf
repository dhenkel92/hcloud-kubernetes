provider "hcloud" {
}

module "network" {
  source = "./src/network"
  name = "net"
  net_ip_range = var.ip_range
  labels = var.labels
  subnet_ip_ranges = var.subnet_ip_ranges
}

module "ssh_keys" {
  source = "./src/ssh"
  ssh_keys = var.ssh_keys
}

module "server" {
  source = "./src/server"
  ssh_keys = module.ssh_keys.ssh_keys
  labels = var.labels
  location = var.location
  network_id = module.network.network_id

  node_type= var.node_type
  node_count = var.node_count
  ip_prefixes = var.ip_prefixes

  pod_ip_cidr = var.pod_ip_cidr
  dns_ip = var.dns_ip
  network_cidr = var.ip_range
}

module "fips" {
  source = "./src/fip"
  fip_count = var.fip_count
  labels = var.labels
  location = var.location
}

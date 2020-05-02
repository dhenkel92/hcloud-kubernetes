provider "hcloud" {}

module "config" {
  source = "../00-config"
}

module "network" {
  source           = "../modules/network"
  name             = "net"
  net_ip_range     = var.ip_range
  labels           = module.config.labels
  subnet_ip_ranges = var.subnet_ip_ranges
}

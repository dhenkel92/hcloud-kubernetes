provider "hcloud" {}

module "ssh_keys" {
  source   = "../modules/ssh"
  ssh_keys = var.ssh_keys
}

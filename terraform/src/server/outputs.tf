output "ips" {
  value = {
      "master" = module.master_nodes.ips,
      "worker" = module.worker_nodes.ips,
  }
}

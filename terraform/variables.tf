variable "ip_range" {
}

variable "subnet_ip_ranges" {
}

variable "ssh_keys" {
}

variable "fip_count" {
}

variable "labels" {
}

variable "location" {
}

variable "node_type" {
  default = {
      master = "cx11"
      worker = "cx11"
  }
}

variable "node_count" {
  default = {
      master = 3
      worker = 3
  }
}

variable "ip_prefixes" {
}

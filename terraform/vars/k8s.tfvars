ip_range = "10.0.0.0/20"

subnet_ip_ranges = {
    master_nodes = "10.0.1.0/24"
    worker_nodes = "10.0.2.0/24"
}

ssh_keys = {}

fip_count = 0

labels = {
    test = 12
}

location = "nbg1"

node_count = {
    worker = 3
    master = 3
}

node_type = {
    master = "cx11"
    worker = "cx21"
}

ip_prefixes = {
    master = "10.0.1.5"
    worker = "10.0.2.11"
}

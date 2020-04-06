ip_range = "10.0.0.0/20"

subnet_ip_ranges = {
    master_nodes = "10.0.1.0/24"
    worker_nodes = "10.0.2.0/24"
}

ssh_keys = {
    "ssh-key" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6kOTAjfKJRoVTg5Y0TWLPiBzHglBmdvCa3B7L7bxN1Im5dW3KBqJoU6ib5l46ZI+0dJGv4ilvy8ykEnH4POuCBKbO/S9fCwQoo/fRKfEFwvQ245LP5m1MOjTV0w6SMus68voFLnShL1hBw8r6l7hl7DWh4YC/beTri/Lks5wpbgmBpoWwe2XhwRMvrvFNcnoRd3H1jZaevSopbQG1esaGvZleTTEBo75bE97RiA12q4KFGt5y7VItidQNxbBfy/BG/QvXkuJjlOd/KjM/PRd9xrzq0ukvP+GNRq9eMh8T0nfxz1wudpkbmuySagI9+EejjvTSjhcTaOlRuRdhqBYD"
}

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

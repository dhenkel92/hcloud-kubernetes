ip_range = "10.0.0.0/20"

subnet_ip_ranges = {
    master_nodes = "10.0.1.0/24"
    worker_nodes = "10.0.2.0/24"
}

ssh_keys = {
    "ssh-key" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC35h+SwNo4jtVYSMdEmdVEj8pEY5dWtiL8wIJe/81pKxOHd8Cglm8FAnzB/Dwu4p+QZcATzSc5Dk5a1Qo5LgHPSp4fe0HHjjm6LX3kU2OAtodO7+zcX4eOFBSOzM/1MO5C4TNN028GW27LN7OV8MFKKGGlbg/QYpYiDh8Wi5axx5WBTrbrrEbeuN5uHYBVTMdOMOyAAlU+QFZKKspWwP5cpkVwLGQ7r2Y0wBHeh0957SxU4fSyqpzJOAcFeZ5ibZST98Kieeih+mbnfdiHdNdxcyq9BJW6T4TYqRuQLss1EMjz7kWnyhFMbidzeI3r/Li5qMDIk6QrKil982E512KTrT6fYoicDX6DiTfcCi16u/kVK40O7f2+xLP21YEOt/Ek4g9tq/qXhBNsi5qXB7dfLAceiG0f+rSnv4XJQlUlApcbkAOXmM8T0FiuYCRu6HojHkZpDyIysIdb14pSnDE6XsfzEy08/47aWg5Xt1DNSYw4y0uzrOnHCsv/N5PrTuc66+BzKXP1Le/XaezRakLLQYwwqt5ShpilBaEGPpyod+2Ff1Azn5xDDuIgomWrnb/kZ7AY+ObUdrGhxe7m6Dl284Gx7Am9l8sel4WJb7nEB/MgTie1yedYKXbLCpV9f2XLi5fnraP1XYJEqQy2/5OyA6wJ09cQ/QxF1+4Odd1b6w=="
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

pod_ip_cidr = "192.168.0.0/24"
dns_ip = "192.168.0.10"

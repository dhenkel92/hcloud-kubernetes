#! /bin/bash

set -ex

apt-get update
apt-get install -y ufw

ufw default deny
ufw allow from any to any port 22
ufw allow from 10.0.0.0/16 to any port 2379
ufw allow from 10.0.0.0/16 to any port 2380

ufw allow from any to any port 6443
ufw allow from 10.0.0.0/16 to any port 10251
ufw allow from 10.0.0.0/16 to any port 10252
ufw allow from 10.0.0.0/16 to any port 8080
ufw allow from 10.0.0.0/16 to any port 10257
ufw allow from 10.0.0.0/16 to any port 10259

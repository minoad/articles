#!/usr/bin/env bash

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install consul

# apt-get update
# apt-get install -y unzip
# CONSUL_VERSION=1.18.0

# wget "https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip"
# unzip consul_${CONSUL_VERSION}_linux_amd64.zip
# mv consul /usr/local/bin/



systemctl enable consul
systemctl restart consul
# Consul Cheat Sheet

1 **Install**

    ```bash
    sudo apt-get update
    sudo apt-get install -y unzip
    CONSUL_VERSION=1.18.0

    wget "https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip"
    unzip consul_1.11.0_linux_amd64.zip
    sudo mv consul /usr/local/bin/

    sudo apt-get update
    sudo apt-get install -y unzip

    wget https://releases.hashicorp.com/consul/1.11.0/consul_1.11.0_linux_amd64.zip
    unzip consul_1.11.0_linux_amd64.zip
    sudo mv consul /usr/local/bin/
    sudo mkdir /etc/consul.d
    sudo touch /etc/consul.d/consul.hcl
    echo 'bind_addr = "0.0.0.0"' | sudo tee -a /etc/consul.d/consul.hcl
    echo 'datacenter = "dc1"' | sudo tee -a /etc/consul.d/consul.hcl
    echo 'server = true' | sudo tee -a /etc/consul.d/consul.hcl
    echo 'bootstrap_expect = 1' | sudo tee -a /etc/consul.d/consul.hcl
    echo 'ui = true' | sudo tee -a /etc/consul.d/consul.hcl
    sudo systemctl restart consul
    ```
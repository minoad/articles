
# Add lookup
add_hosts(){
    while read -r line; do
        if ! grep -Fxq "$line" /etc/hosts; then
            echo "$line" | sudo tee -a /etc/hosts
        fi
    done <<EOF
192.168.1.16 ansible01 ansible01.cluster.local
192.168.1.17 consul01 consul01.cluster.local
192.168.1.10 k8s-service-host-00 k8s-service-host-00.cluster.local
192.168.1.11 k8s-worker-00 k8s-worker-00.cluster.local
192.168.1.12 k8s-worker-01 k8s-worker-01.cluster.local
EOF
}

cd terraform
ansible-inventory -i inventory.yml --graph --vars
ansible-playbook -i inventory.yml ../ansible/default_ubuntu_install.yaml
ansible-playbook -i inventory.yml -l mgmt ../ansible/install_python_latest.yaml
ansible-playbook -i inventory.yml ../ansible/install_consul_server.yaml


remove_keys(){
    ssh-keygen -f "/home/minoad/.ssh/known_hosts" -R "192.168.1.16"
    ssh-keygen -f "/home/minoad/.ssh/known_hosts" -R "192.168.1.17"
    ssh-keygen -f "/home/minoad/.ssh/known_hosts" -R "192.168.1.10"
    ssh-keygen -f "/home/minoad/.ssh/known_hosts" -R "192.168.1.11"
    ssh-keygen -f "/home/minoad/.ssh/known_hosts" -R "192.168.1.12"
}

#testing
ansible-playbook -i inventory.yml ../ansible/test.yaml
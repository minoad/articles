# Deployment using Terraform

## Summary

terraform instances.yaml file defines the instances to be deployed.

- The service host is responsible for hosting Kubernetes services.
- The worker nodes are designated to host pods and other Kubernetes resources.
- Management servers are utilized to host services such as Ansible, Consul, LDAP, and more.


## Deploy the Virtual Infrastructure

1. **Run terraform init** to initialize the terraform configuration.
1. **Run terraform plan** to see the changes that will be applied.
1. **Run terraform apply** to apply the changes.

## Setup Ansible

Once terraform has been run, we can use the statefile to run ansible playbooks to configure the instances.
First we want to prepare ansible on the management hosts.  This begins by setting up the python environment and installing ansible.

### Setup Python

```shell
ansible-playbook -l mgmt -i inventory.yml ansible/install_python_latest.yaml
```

1. **Inventory for ansible** is generated from the terraform state file.
1. TODO: DNS step here.
1. **Install python and ansible on ansible01** to run the ansible playbooks.
```shell
sudo add-apt-repository ppa:deadsnakes/ppa
apt update
apt install -y python3.12 python3.12-venv python3.12-dev python3-pip
python3.12 -m venv .venv
source venv/bin/activate
python -m pip install pip --upgrade
python -m pip install pipx --upgrade
python -m pipx install ansible --include-deps
python -m pipx ensurepath
source ~/.bashrc && source venv/bin/activate
pipx inject --include-apps ansible argcomplete
export PATH="$PATH:/root/.local/bin"
activate-global-python-argcomplete --user
source source "/root/venv/lib/python3.12/site-packages/argcomplete/bash_completion.d/_python-argcomplete"
```
1. ** If you need to upgrade an existing ansible deployment **
```shell
pipx upgrade --include-injected ansible
```
1. **Prepare ansible collection from kubernetes**
```shell
ansible-inventory -i inventory.yml --graph --vars
ansible-playbook -i inventory.yml ansible/default_ubuntu_install.yaml

ansible-playbook -i /etc/ansible/terraform.py playbook.yml
```

Troubleshooting
```shell
TODO: need a thing for this.
v startvm --type emergencystop terraform_k8s-worker-00_1714767734141_89369
v unregistervm --delete terraform_k8s-worker-00_1714767734141_89369

vl | cut -d '"' -f 2 | xargs -I {} vboxmanage startvm --type emergencystop {}
vl | cut -d '"' -f 2 | xargs -I {} vboxmanage unregistervm --delete {}

# ip=192.168.1.11 service_type=kubernetes_workers VAGRANTFILE_HASH=6b2ce28298ef962615358afe00ce829c mem=2048 hostname=k8s-worker-00 cpus=2 vagrant up

# ip=192.168.1.11 service_type=kubernetes_workers VAGRANTFILE_HASH=6b2ce28298ef962615358afe00ce829c mem=2048 hostname=k8s-worker-00 cpus=2 vagrant destroy --force
# use vl to figure out what did not apply
terraform destroy
env TF_LOG=TRACE VAGRANT_LOG=info terragrunt apply -auto-approve 2>&1 | tee ~/infra_deploy.log 

# Get the commands that were sent to vagrant
cat ~/infra_deploy.log | grep "Environment:" | tr -s ' ' | cut -d '[' -f 3 | cut -d ']' -f 1
```

add the following to ~/.ansible.cfg
```shell
[defaults]
host_key_checking = False
```


# resource "vagrant_vm" "my_vagrant_vm" {
#   env = {
#     # force terraform to re-run vagrant if the Vagrantfile changes
#     VAGRANTFILE_HASH = md5(file("./Vagrantfile")),
#     vm_ip = "192.168.1.10",
#     GFILE = "this is a file",
#   }
#   get_ports = true
#   # see schema for additional options
# }

# output "host_port" {
#   value = vagrant_vm.my_vagrant_vm.ports[0][0].host
# }

locals {
  #yaml_rg = yamldecode(file("${path.module}/instances.yaml"))
  # yaml_rg = flatten([for service_type in yamldecode(file("${path.module}/instances.yaml")): [for host in service_type: {hostname = host.hostname, ip = host.ip, mem = host.mem, cpus=host.cpus, launch_script=host.launch_script}]])
  inventory_data = [for service_key, services in yamldecode(file("${path.module}/instances.yaml")):[
    for hostname, system in services: {
      service_type= service_key, 
      hostname=hostname, 
      ip=system.ip, 
      mem=system.mem, 
      cpus=system.cpus, 
      launch_script=system.launch_script}
      ]
    ]
  system_details = flatten(local.inventory_data)
  system_map = tomap({for system in local.system_details: "${system.service_type}.${system.hostname}" => system})
}

resource "vagrant_vm" "vagrant_infra_vms" {
    for_each = local.system_map
    name = each.value.hostname
    env = {
        service_type = each.value.service_type,
        VAGRANTFILE_HASH = md5(file("./Vagrantfile")),
        hostname = each.value.hostname,
        ip = each.value.ip,
        cpus = each.value.cpus,
        mem = each.value.mem,

    }
    get_ports = true
}

resource "ansible_host" "all_hosts" {
  for_each = vagrant_vm.vagrant_infra_vms
  
  name = each.value.env.hostname
  groups = ["all", each.value.env.service_type]
  variables = {
    ansible_user = "vagrant"
    ansible_ssh_private_key_file = "~/.ssh/id_rsa"
  }
}

# resource "ansible_host" "ansible_host" {
#   name = vagrant_vm.vagrant_infra_vms["mgmt.ansible01"].env.ip
#   #name = "192.168.86.21"
#   groups = ["ansible"]
#   variables = {
#     ansible_user = "vagrant"
#     ansible_ssh_private_key_file = "~/.ssh/id_rsa"
#   }
# }
# TODO: right a script to automate this.
# ssh-keygen -f "/home/minoad/.ssh/known_hosts" -R "192.168.1.16"
# ssh-keygen -f "/home/minoad/.ssh/known_hosts" -R "192.168.1.17"
# ssh-keygen -f "/home/minoad/.ssh/known_hosts" -R "192.168.1.10"
# ssh-keygen -f "/home/minoad/.ssh/known_hosts" -R "192.168.1.11"
# ssh-keygen -f "/home/minoad/.ssh/known_hosts" -R "192.168.1.12"
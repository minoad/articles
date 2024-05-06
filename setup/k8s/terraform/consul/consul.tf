resource "null_resource" "get-hashicorp-key" {
  provisioner "local-exec" {
    command = "if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]; then wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg; fi"
  }
}

resource "local_file" "terraform-apt-repo" {
  filename = "/etc/apt/sources.list.d/hashicorp.list"
  file_permission = 0644
  depends_on = [ null_resource.get-hashicorp-key ]
  content  = <<EOT
deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main
EOT
}

resource "local_file" "consul-directory" {
  filename = "/opt/consul/create"
  depends_on = [ null_resource.get-hashicorp-key ]
  content  = <<EOT
created
EOT
}

resource "null_resource" "install_consul" {
  provisioner "local-exec" {
    command = "apt-get update && apt-get -o Dpkg::Options::='--force-confold' install -y consul"
  }
  depends_on = [ local_file.terraform-apt-repo]
}

# resource "null_resource" "enp0s8-ipaddr"{
#     provisioner "local-exec" {
#         command = "export IPADDR=$(ip addr show enp0s8 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)"
#     }
    
# }

data "external" "enp0s8-ipaddr" {
  #program = ["bash", "-c", "ip addr show enp0s8 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1"]
  program = ["bash", "-c", "echo {'ip': $(ip addr show enp0s8| grep 'inet ' | awk '{print $2}')}"]
}

output "listen_address" {
  value = "${data.external.enp0s8-ipaddr.result.ip}"
}

resource "local_file" "consul_config" {
  filename = var.consul_config_file
  depends_on = [ data.external.enp0s8-ipaddr ]
  file_permission = 0644
  content  = <<EOT
datacenter = "0.0.0.0" #${var.consul_datacenter}"
data_dir = "/opt/consul"
client_addr = "${data.external.enp0s8-ipaddr}"
server = true
server = true
bootstrap_expect = 1
ui = true
EOT
}

resource "local_file" "consul_unit" {
  filename = var.consul_service_file
  file_permission = 0644
  content  = <<EOT
[Unit]
Description=Consul Service
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
User=root
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOT
}

resource "null_resource" "register-consul-service" {
  provisioner "local-exec" {
    command = "sudo systemctl daemon-reload && sudo systemctl enable consul && sudo systemctl start consul"
  }
  depends_on = [ local_file.consul_unit, ]
}
variable "consul_datacenter" {
  description = "The datacenter name"
  default     = "dc1"
}

variable "consul_server" {
  description = "Whether this node should run as a server"
  default     = true
}

variable "consul_path" {
  description = "The path to the Consul binary"
  default     = "/usr/bin/consul"
}

variable "consul_config_file"{
    description = "The path to the Consul configuration file"
    default     = "/etc/consul.d/consul.hcl"
}

variable "consul_service_file" {
    description = "The path to the Consul service file"
    default     = "/etc/systemd/system/consul.service"
}
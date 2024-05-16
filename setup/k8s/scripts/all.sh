#!/usr/bin/env bash

apt-get update
apt-get install -y gnupg software-properties-common
mkdir -p /etc/facts

modprobe overlay
modprobe br_netfilter

# bridged traffic to iptables is enabled for kube-router.
cat >> /etc/ufw/sysctl.conf <<EOF
net/bridge/bridge-nf-call-ip6tables = 1
net/bridge/bridge-nf-call-iptables = 1
net/bridge/bridge-nf-call-arptables = 1
EOF

## sysctl --all
# add this to the call above?
sysctl -w net.ipv4.ip_forward=1
sysctl -p
sysctl --system

# lets see if facter is the best way to do this.
gem install facter
facter --json > /etc/facts/facts.json
#!/usr/bin/env bash

mkdir -p /tmp/patches

rm -f /etc/hosts && mv /tmp/hosts /etc/hosts
mkdir -p '/root/.kube/' '/home/vagrant/.kube/' '/etc/facts/'

echo "prepare kernel"
tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

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

echo "apt install"
# Apt install
mkdir -m 0755 -p /etc/apt/keyrings/

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
swapoff -a && sed -i '/swap/d' /etc/fstab
apt-get update && apt-get install -y ruby-rubygems ebtables ethtool net-tools avahi-daemon libnss-mdns curl gpg apt-transport-https ca-certificates software-properties-common jq kubelet kubeadm kubectl
curl -LO https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl

echo "Prepare Containerd"
# Install containerd
mkdir /etc/containerd
cp /tmp/containerd_config.toml /etc/containerd/config.toml
wget --quiet https://github.com/containerd/containerd/releases/download/v1.7.15/containerd-1.7.15-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-1.7.15-linux-amd64.tar.gz
wget --quiet https://raw.githubusercontent.com/containerd/containerd/main/containerd.service -O /etc/systemd/system/containerd.service
systemctl daemon-reload
systemctl enable --now containerd

wget --quiet https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc

systemctl restart containerd
systemctl enable containerd

# lets see if facter is the best way to do this.
gem install facter
facter --json > /etc/facts/facts.json

echo "alias k=kubectl" >> /etc/bash.bashrc
echo "complete -F __start_kubectl k" >> /etc/bash.bashrc

# Calico deploy
# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
curl -L https://github.com/projectcalico/calico/releases/download/v3.27.3/calicoctl-linux-amd64 -o calicoctl
curl -L https://github.com/projectcalico/calico/releases/download/v3.27.3/calicoctl-linux-amd64 -o kubectl-calico
chmod +x ./calicoctl
chmod +x kubectl-calico
mv ./calicoctl /usr/local/bin/
mv ./kubectl-calico /usr/local/bin/
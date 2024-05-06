#!/usr/bin/env bash


# ipaddr="$(ip -4 address show enp0s8 | grep inet | tr -s ' ' | cut -d ' ' -f 3 | cut -d '/' -f 1)"
# mkdir -p /tmp/patch/

# cat <<EOF > /tmp/patch/kubeletconfiguration0+merge.yaml
# apiVersion: kubelet.config.k8s.io/v1beta1
# kind: KubeletConfiguration
# address: "$ipaddr"
# # rest of your configuration
# EOF

# kubeadm join 192.168.1.10:6443 --token $token --discovery-token-ca-cert-hash $token_discovery_hash --patches /tmp/patch/ | tee /tmp/kubeadm_join.log
#--discovery-token-ca-cert-hash $token_discovery_hash
kubeadm join --config /tmp/kubeadm_worker_join.yaml
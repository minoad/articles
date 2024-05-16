#!/usr/bin/env bash

# TODO: Copy this file to the servers and enable it for usage.

function prepare_kubelet_config(){
  ip=$(ip -4 address show enp0s8 | grep inet | tr -s ' ' | cut -d ' ' -f 3 | cut -d '/' -f 1)
}
# kubelet uses the IP address reported by the cloud provider if it exists, or the first non-loopback ipv4 address (code here) if there is no cloud provider. In addition, it could be overwritten by kubelet flags.
# You might want to check if there are any differences in your nodes.

function set_kube_config() {
  # @param $1: kubeconfig file
  KUBECONFIG_FILE=$1

  if [[ -n "$KUBECONFIG_FILE" ]]; then
    if [[ -f "$KUBECONFIG_FILE" ]]; then
      export KUBECONFIG=$KUBECONFIG_FILE
    else
      echo "Error: Kubeconfig file $KUBECONFIG_FILE does not exist."
      return 1
    fi
  else
    if [[ -f "$HOME/.kube/config" ]]; then
      export KUBECONFIG="$HOME/.kube/config"
    else
      echo "Error: Default kubeconfig file $HOME/.kube/config does not exist."
      return 1
    fi
  fi
}

function check_for_issue() {
  # @example check_for_issue 1
  local check_type=$1
  local kubeconfig_file=$2

  set_kube_config "$kubeconfig_file"

  trap 'unset KUBECONFIG_FILE' EXIT

  if [[ -z "$check_type" ]]; then
    check_type=0
  fi

  if [[ $check_type == 1 || $check_type == 2 || $check_type == 3 ]]; then
    set_kube_config "$kubeconfig_file"
    if [[ $? -ne 0 ]]; then
      echo "Error setting KUBECONFIG"
      return 1
    fi
    troubleshoot_k8s_cluster "$kubeconfig_file" 2>&1 | grep -i -E "warn|error|fail"
  fi
  k get nodes
}

function check_vagrant() {
  echo "Vagrant version:"
  vagrant --version

  echo "Vagrant global status:"
  vagrant global-status

  echo "Vagrant box list:"
  vagrant box list

  echo "Vagrant running boxes and their IPs:"
  for id in $(vagrant global-status | awk '/running/{print $1}')
  do
    echo "Box ID: $id"
    #(cd $(vagrant global-status | awk "/^${id}/{print \$5}") && vagrant ssh -c "hostname -I")
  done
}

function get_k8s_info() {
  # Accept a config file and run some validation on it.

  if [[ -z "$2" ]]; then
    # TODO: Add a check for the existing env varible.  not sure how i want to do this yet.
    KUBECONFIG_FILE=$HOME/.kube/config
    echo "using default kubeconfig file: $KUBECONFIG_FILE"
  fi

  export KUBECONFIG=$KUBECONFIG_FILE

  # cluster
  echo "title_for_error_check=cluster_info fail"
  kubectl cluster-info 2>&1
  echo "title_for_error_check=cluster_info_dump fail"
  kubectl cluster-info dump 2>&1
  echo "title_for_error_check=cluster_get_cm_kubeadmin_config fail"
  kubectl -n kube-system get cm kubeadm-config 2>&1 #-o yaml
  
  # nodes
  echo "title_for_error_check=nodes_spec fail"
  kubectl get nodes -o jsonpath='{.items[*].spec}' 2>&1
  echo "title_for_error_check=nodes_spc_podcidr fail"
  kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}' 2>&1
  
  # network
  echo "title_for_error_check=kubeadm-config_configmanp fail"
  kubectl  --namespace kube-system get configmap kubeadm-config -o yaml 2>&1
}

#sudo journalctl --unit kubelet


function calico_check() {
    KUBECONFIG_FILE=$1

    set_kube_config "$kubeconfig_file"

    trap 'unset KUBECONFIG_FILE' EXIT

    #export KUBECONFIG=$KUBECONFIG_FILE
    export DATASTORE_TYPE=kubernetes

    # Calico nodes
    calicoctl node status -o wide

    # Calico network
    calicoctl --allow-version-mismatch get nodes -o wide
    calicoctl --allow-version-mismatch get hostEndpoints -o wide
    calicoctl --allow-version-mismatch get bgpConfiguration -o wide
    calicoctl --allow-version-mismatch get bgpPeer -o wide
    calicoctl --allow-version-mismatch get felixConfiguration -o wide
    calicoctl --allow-version-mismatch get globalNetworkPolicy -o wide
    calicoctl --allow-version-mismatch get globalNetworkSet -o wide
    calicoctl --allow-version-mismatch get hostEndpoint -o wide
    calicoctl --allow-version-mismatch get ipPool -o wide
    calicoctl --allow-version-mismatch get ipReservation -o wide
    calicoctl --allow-version-mismatch get kubeControllersConfiguration -o wide
    calicoctl --allow-version-mismatch get networkPolicy -o wide
    calicoctl --allow-version-mismatch get networkSet -o wide
    calicoctl --allow-version-mismatch get node -o wide
    calicoctl --allow-version-mismatch get profile -o wide
    calicoctl --allow-version-mismatch get workloadEndpoint -o wide
    calicoctl --allow-version-mismatch ipam check -o wide
    calicoctl --allow-version-mismatch ipam show -o wide
}

function get_cri-o_endpoint(){
  # Set the endpoint
  ## Defaults unix:///run/containerd/containerd.sock unix:///run/crio/crio.sock unix:///var/run/cri-dockerd.sock
  local endpoint
  endpoint=$(ps -f $(pgrep kubelet) | sed -n -e 's/.*--container-runtime-endpoint=\([^ ]*\).*/\1/p')
  echo "$endpoint" 
}

function cri-o_state(){
  # Set the endpoint
  
  local cri_endpoint
  cri_endpoint=$(get_cri-o_endpoint)
  echo "CRI-O endpoint: $cri_endpoint"
  crictl --runtime-endpoint "$cri_endpoint" pods 
  crictl --runtime-endpoint "$cri_endpoint" inspectp
  crictl --runtime-endpoint "$cri_endpoint" info # view CRI runtime info
  crictl --runtime-endpoint "$cri_endpoint" stats # does everything look normal?
  crictl --runtime-endpoint "$cri_endpoint" --debug stopp # [sic] stop a pod and print debug logs (useful if a pod is stuck terminating)
}

function check_kubelet_state() {
  KUBECONFIG_FILE=$1

  if [[ -z "$KUBECONFIG_FILE" ]]; then
    echo "Please provide a kubeconfig file."
    return 1
  fi

  # if [[ -z "$NODENAME" ]]; then
  #   echo "Please provide a node name."
  #   return 1
  # fi

  export KUBECONFIG=$KUBECONFIG_FILE

  echo "Checking kubelet logs..."
  journalctl -xe --unit kubelet

  echo "Checking kubelet service status..."
  systemctl status kubelet

  echo "Checking pods on the node..."
  kubectl get pods -o wide # | grep $NODENAME
  
  containerd config dump # see the output of the final main config with imported in subconfig files

  diff -y <(containerd config default) <(containerd config dump)
  systemd-cgls # view the cgroups under `containerd.service`

  # Not sure how i feel about this
  for pid in $(pgrep containerd-shim-runc-v2); do kill -USR1 "$pid"; done
  journalctl -xe --unit containerd | grep shim | tee /tmp/containerd-shim.log

  runc --root /run/containerd/runc/k8s.io/ events
  runc --root /run/containerd/runc/k8s.io/ state

  #kubelet_command=$(ps -ef | grep kubelet | grep -v grep | awk '{print $9}')
}

function get_all_config_by_label(){
  # @example get_all_config_by_label hello_world app.kubernetes.io/name=hello-world-8081
  # Get all configmaps with a specific label
  # @param $1: label
  # @param $2: namespace
  
  local namespace="$1"
  local label="$2"
  output_path="data/${namespace}_${label}"
  mkdir -p $output_path
  kubectl --namespace=$namespace get configmaps -l $label -o json > "$output_path/configmaps.json"
  kubectl --namespace=$namespace get all -l app.kubernetes.io/name=hello-world-8081 -o json > "$output_path/all.json"

}







# # Confirm that kubelet is configured to actually use containerd. The flags — container-runtime=remote and --container-runtime-endpoint=unix:///run/containerd/containerd.sock need to be set.

# # "lastCNILoadStatus": "cni config load failed: no network config found in /etc/cni/net.d: cni plugin not initialized: failed to load cni config",
# #   "lastCNILoadStatus.default": "cni config load failed: no network config found in /etc/cni/net.d: cni plugin not initialized: failed to load cni config"

# k -n tigera-operator logs pod/$(k get pods --all-namespaces | grep tigera-operator | tr -s ' ' | cut -d ' ' -f 2)

# ## Deploy an easy sample

# ## hello-node.yaml
# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: helloworld
# spec:
#   selector:
#     matchLabels:
#       app: helloworld
#   replicas: 1 # tells deployment to run 1 pods matching the template
#   template: # create pods using pod definition in this template
#     metadata:
#       labels:
#         app: helloworld
#     spec:
#       containers:
#       - name: helloworld
#         image: karthequian/helloworld:latest
#         ports:
#         - containerPort: 80
# # ---
# # apiVersion: v1
# # kind: Service
# # metadata:
# #   name: hello-node
# # spec:
# #   type: NodePort
# #   ports:
# #     - port: 80
# #       nodePort: 30007
# #   selector:
# #     app: hello-node

# # use loadbalancer.  only access within the cluster
# ---
# apiVersion: v1
# kind: Service
# metadata:
#   name: hello-node
# spec:
#   type: LoadBalancer
#   ports:
#   - port: 80
#   selector:
#     app: hello-node
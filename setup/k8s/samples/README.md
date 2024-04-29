# Use sample to test

From the physical host

Kubernetes has five types of services:

Cluster IP. This is the default service, which is used to expose a service on a cluster-internal IP. This means the service is only accessible from inside the cluster.
Node Port. This exposes a service on each node's IP at a static port so the service is accessible from outside the cluster.
Load Balancer. This uses a cloud provider's load balancer to access a service from outside the cluster.
External Name. This maps a service to the contents of a predefined external name field by returning a CNAME record with its value.
Headless. This headless service is used for Pod grouping when a stable IP address is not required.

### After deploy network configuration

- Collect network configuration

```bash
# Service
service_clusterip=$(kubectl --namespace=hello-world get service -o=jsonpath='{.items[0].spec.clusterIP}')
service_nodeport=$(kubectl --namespace=hello-world get service -o=jsonpath='{.items[0].spec.ports[0].nodePort}')
service_port=$(kubectl --namespace=hello-world get service -o=jsonpath='{.items[0].spec.ports[0].port}')
service_targetport=$(kubectl --namespace=hello-world get service -o=jsonpath='{.items[0].spec.ports[0].targetPort}')

# Pod
pod_calico_podip=$(kubectl --namespace=hello-world get pod -o=jsonpath='{.items[0].metadata.annotations["cni.projectcalico.org/podIP"]}')
pod_hostip=$(kubectl --namespace=hello-world get pod -o=jsonpath='{.items[0].status.hostIP}')
pod_podip=$(kubectl --namespace=hello-world get pod -o=jsonpath='{.items[0].status.podIP}')

echo "service_clusterip: $service_clusterip service_nodeport: $service_nodeport service_port: $service_port service_targetport: $service_targetport pod_calico_podip: $pod_calico_podip pod_hostip: $pod_hostip pod_podip: $pod_podip"
```

- Access service
  - From physical host
    - `curl http://$pod_hostip:$service_nodeport`
  - From member of the cluster (master or worker)
    - `curl http://$service_clusterip:$service_targetport`
    - `curl http://$pod_hostip:$service_nodeport`
    - `curl http://$pod_podip:$service_targetport`
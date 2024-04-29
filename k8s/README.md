# K8s ARticles

- [K8s 1.30 Deployment using Vagrant and Containerd](k8s_1.30_vagrant/README.md)


## TODOS

- [ ] Create a namespace for monitoring tools
  - `kubectl create namespace monitoring`
- [ ] Deploy Prometheus
  - `kubectl apply -f https://github.com/prometheus-operator/prometheus-operator/blob/main/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml`
- [ ] Deploy Grafana
  - `kubectl apply -f https://raw.githubusercontent.com/grafana/helm-charts/main/charts/grafana/values.yaml`
- [ ] Download the Istio release
  - `curl -L https://istio.io/downloadIstio | sh -`
- [ ] Install Istio
  - `cd istio-*`
  - `export PATH=$PWD/bin:$PATH`
  - `istioctl install --set profile=demo -y`
- [ ] Enable automatic sidecar injection for a namespace
  - `kubectl label namespace default istio-injection=enabled`
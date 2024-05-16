# Kubernetes

--namespace monitoring -o wide

## Default namespace

```shell
NS=monitoring
kubectl config set-context --current --namespace=$NS
# prefer to use kcsc $NS
```

## quick port forward to a pod

```shell
NS=monitoring
kcsc $NS
prometheus_pod=$(kubectl get pods -o=jsonpath="{$.items[0].metadata.name}" --namespace=$NS)
kubectl port-forward $prometheus_pod 8080:9090 --namespace=$NS
```
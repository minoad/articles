# Remaining Todos

- [ ] Add overall makefile
- [ ] add chmod +x scripts/*.sh in the makefile.
- [ ] add a script for post kubernetes setup including monitoring.
- [ ] add a script for post kubernetes setup including ingress.
- [ ] automate the phys bridge deployment and add tons of checks to make sure someone doesn't accidentally kill their physical machines network connection.
- [ ] move the inline scripts to a script file.
- [ ] remove the duplicated branch.  use this but detect type `%w{k8s master k8snode01 k8snode02}.each_with_index do |name, i|`
- [ ] generate the yaml files from a config or dotenv file.
- [ ] template yaml files
- [ ] set persistent storage for prometheus
- [ ] add kubectl version update `sudo mv kubectl $(which kubectl) `
- [ ] templatize dropins .yaml files
- [ ] do this with envsubst

```shell
# pipe into less
envsubst < config.txt | less

# pipe a deployment "deploy.yml" into kubectl apply
envsubst < deploy.yml | kubectl apply -f -
```
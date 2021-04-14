The `awx-on-docker` directory is for setting up docker outside of k8s this mimics a server installation and could potentially work with azure container instances or docker directly. You can use this to edit and build source code if testing or exploring changes. 
### cluster

For mimicking an aks setup we first need a keypair. These steps setup a base cluster to which awx can be deployed. 

Generate a dirty key pair for testing
```bash
scripts/generate-key-pair.sh
```
Set up a fresh new test cluster
```bash
terraform plan && terraform apply
```
Get nodePort url for k8s ingress
```
scripts/get-k8s-ingress-url.sh
```
cert-manager crds useful commands
```
kubectl get/describe certificate --all-namespaces
kubectl get/describe certificaterequest --all-namespaces
kubectl get/describe clusterissuer/issuer --all-namespaces
kubectl get/describe order <order> --all-namespaces
```

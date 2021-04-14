kubectl delete deployment awx
kubectl delete deployment awx-operator
kubectl delete statefulset awx-postgres
kubectl delete service awx-postgres awx-service
kubectl delete pod awx-postgres-0
kubectl delete crds awxs.awx.ansible.com
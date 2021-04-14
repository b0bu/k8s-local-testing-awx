PASSWORD=$(kubectl get secrets -n default awx-admin-password -o template --template={{.data.password}} | base64 -d)
nodePort=$(kubectl get service -n ingress-nginx -o json | jq '.items[].spec.ports[]|select(.name == "https")|.nodePort'|grep -v null)
echo username:admin password:${PASSWORD}
echo https://awx.example.com:${nodePort}/

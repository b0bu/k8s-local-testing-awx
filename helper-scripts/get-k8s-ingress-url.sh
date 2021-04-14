nodePort=$(kubectl get service -n ingress-nginx -o json | jq '.items[].spec.ports[]|select(.name == "https")|.nodePort'|grep -v null)
echo https://kubernetes.docker.internal:${nodePort}/healthz

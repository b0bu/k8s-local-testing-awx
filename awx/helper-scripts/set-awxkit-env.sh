# for testing
PASSWORD=$(kubectl get secrets -n default awx-admin-password -o template --template={{.data.password}} | base64 -d)
export TOWER_HOST=https://awx.example.com:30789
export TOWER_USERNAME=admin 
export TOWER_PASSWORD=${PASSWORD}
TOKEN=$(awx login -k | jq '.token' | tr -d '"')
export TOWER_TOKEN=${TOKEN}

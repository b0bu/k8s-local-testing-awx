# external db running outside of k8s
PASSWORD=1234
docker run -it --rm --name psql-test-connection -e PGPASSWORD=1234 postgres psql -h kubernetes.docker.internal -U awx -c '\dt'
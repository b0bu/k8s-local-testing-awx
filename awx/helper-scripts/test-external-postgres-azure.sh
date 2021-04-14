# external db running outside of k8s
AWX_POSTGRES_PASS=$(sops -d secrets/secrets.yaml | yq e '.awx-postgres-pass' -)
HOST=awx-external-postgres.postgres.database.azure.com
USER=psqladminun@awx-external-postgres
DBNAME=awx

docker run -it --rm --name psql-test-connection -e PGPASSWORD=${AWX_POSTGRES_PASS} postgres psql -h ${HOST} -U ${USER} -d ${DBNAME} -c '\conninfo'
docker run -it --rm --name psql-test-connection -e PGPASSWORD=${AWX_POSTGRES_PASS} postgres psql -h ${HOST} -U ${USER} -d ${DBNAME} --list
docker run -it --rm --name psql-test-connection -e PGPASSWORD=${AWX_POSTGRES_PASS} postgres psql -h ${HOST} -U ${USER} -d ${DBNAME} -c '\dt'

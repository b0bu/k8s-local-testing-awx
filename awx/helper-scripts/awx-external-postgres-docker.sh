# external db running outside of k8s

# example awx-external-postgres-docker.sh 1234 awx refresh
# example awx-external-postgres-docker.sh 1234 awx

PASSWORD=$1
HOST=kubernetes.docker.internal
USER=$2
DBNAME=awx
CONTAINER_NAME=awx-external-postgres

if [ ! -z "$3" ]; then
    echo "running clean up"
    echo "stopping container"
    docker container stop ${CONTAINER_NAME}
    echo "removing container"
    docker container rm ${CONTAINER_NAME}
    echo "removing volume"
    docker volume rm ${CONTAINER_NAME}-vol
    echo "creating volume"
    docker volume create ${CONTAINER_NAME}-vol
    echo "clean up complete\n"
fi

# no --rm on awx-external-postgres so that it can be stopped for testing. 
docker run --name ${CONTAINER_NAME} -v ${CONTAINER_NAME}-vol:/var/lib/postgresql/data -p 5432:5432 -e POSTGRES_USER=${USER} -e POSTGRES_DB=${DBNAME} -e POSTGRES_PASSWORD=${PASSWORD} -d postgres
echo "container created..."
sleep 2

echo "\ntest connection"
docker run -it --rm --name psql-test-connection -e PGPASSWORD=${PASSWORD} postgres psql -h ${HOSTNAME} -U ${USER} -d ${DBNAME} -c "\conninfo"
echo "\nlist contents"
docker run -it --rm --name psql-test-connection -e PGPASSWORD=${PASSWORD} postgres psql -h ${HOSTNAME} -U ${USER} -d ${DBNAME} --list
echo "\nlist table information for ${DBNAME}"
docker run -it --rm --name psql-test-connection -e PGPASSWORD=${PASSWORD} postgres psql -h ${HOSTNAME} -U ${USER} -d ${DBNAME} -c "\dt"

docker container ls --filter name=postgres
# test external connection from within test cluster
#kubectl exec -it awx-postgres-0 -n default -- /bin/bash -c "PGPASSWORD=${PASSWORD} psql -h kubernetes.docker.internal -U awx -c '\conninfo'"
# do this from awx-task container. 
#kubectl exec -it awx-postgres-0 -n default -- /bin/bash -c "PGPASSWORD=${PASSWORD} psql -h kubernetes.docker.internal -U awx -c '\conninfo'"
# external db running outside of k8s

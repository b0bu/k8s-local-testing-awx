
### awx
Note that the ingress url for awx can be set as part of `awx.yaml`  and needs to be added to the /etc/hosts file when testing. `127.0.0.1       kubernetes.docker.internal awx.example.com`

Deploy the awx-operator reconsiliation loop. This is deployed to the default namespace by default.

![installation](https://user-images.githubusercontent.com/20089429/114378094-44104180-9b7f-11eb-80d4-9c322a8b6116.gif)


This will give you a fully working awx installation.

<img width="676" alt="Screenshot 2021-04-12 at 10 58 52" src="https://user-images.githubusercontent.com/20089429/114377085-2db5b600-9b7e-11eb-8f57-61766e01b45c.png">


Get the frontend nodePort url for connectioning to awx:
```
# spits out username and password
awx/scripts/get-awx-login-url.sh
```
### external postgres

This can be done either to a docker instance external to k8s for testing or direct to azure. The appropriate connection string details have to be set in `awx/awx.yaml` assuming the db exists else the `awx-postgres-0 ` pod is used.

```yaml
#connect to azure test db server instance
host: awx-external-postgres.postgres.database.azure.com
port: "5432"
database: awx
username: psqladminun@awx-external-postgres
password: "LetjIma1o3uQYbs2cq1GJYkI!"

# connect to local docker instance (external to k8s)
host: kubernetes.docker.internal
port: "5432"
database: awx
username: awx
password: "1234"
```
#### docker
Note this db can be stopped and started using `docker container stop/start <container-uid>` for testing. 
```bash
scripts/setup-external-postgres.sh
```
Connect reconcilistion loop to external db test.  Due to how /etc/hosts name are resolved the db connection string is the first name `kubernetes.docker.internal`
```bash
kubectl apply -f awx-postgres-configuration.yaml
```
Once patched the db migation will start, when complete this script will test the db has been populated.
```
scripts/test-migrated-awx-db.sh
```

If you remove the db entirly as if you were rebuilding it back from scratch then updating the awx.yaml or deleteing a pod causes the reconsilitation loop to rebuild the entire db back for you. This can take a few minutes. The awx endpoint will show as this in the browser:

<img src="https://user-images.githubusercontent.com/20089429/114372717-c39b1200-9b79-11eb-9565-f5b2d4babfcf.gif" width="600" height="400">

#### azure

Create a db, note that connection testing can be done by disabling the firewall rule temporarily.
```bash
cd awx && terraform apply
```
Test that to db is populated and working
```bash
scripts/test-external-postgre-azure.sh
```
View logging
```bash
# view migration logging
kubectl logs awx-operator-57bcb58f5-2v7kj -f
# view web frontend logging
kubectl logs awx-68db7445d-xcpmr -c awx-web -f
```
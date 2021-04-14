mkdir ../self-cert
openssl genrsa -out ../self-cert/root-private-key.pem 2048 
openssl req -x509 -new -nodes -key ../self-cert/root-private-key.pem -sha256 -days 1024 -out ../self-cert/root-public-crt.pem

AWX_ADMIN_PASS=$(kubectl get secrets awx-admin-password -o template --template='{{ .data.password }}' | base64 -d)
SSH_KEY_PASS=$(sops -d secrets/secrets.yaml | yq e '.ssh-key-pass' -)
SOPS_AGE_RECIPIENTS=age1z9de3wx4d07y4w727y7lhuvez4eugg77xeee76eua4wkhw4r2vns02gksx
AWX_POSTGRES_PASS=$(sops -d secrets/secrets.yaml | yq e '.awx-postgres-pass' -)

# in case of dns cache issues, flush. macos only. 
dscacheutil -flushcache

az keyvault secret set --vault-name "awx-test-s38f893" --name "awx-admin-pass" --value ${AWX_ADMIN_PASS}
az keyvault secret set --vault-name "awx-test-s38f893" --name "ssh-key-pass" --value ${SSH_KEY_PASS}
az keyvault secret set --vault-name "awx-test-s38f893" --name "awx-postgres-pass" --value ${AWX_POSTGRES_PASS}

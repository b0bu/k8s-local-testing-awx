
data local_file "ssh_key_data" {
  filename = pathexpand("~/.ssh/id_rsa")
}

// resource null_resource "ssh_key_data" {
//   triggers = {
//     manifest_sha1 = sha1(data.local_file.ssh_key_data.content)
// }

resource awx_credential_scm "ac-obiar-scm-credentials" {
    name               = "ac-obair"
    organisation_id    = awx_organization.arnoldclark.id
    description        = "added by tf and other useful description info"
    ssh_key_data       = data.local_file.ssh_key_data.content
    ssh_key_unlock     = data.azurerm_key_vault_secret.ssh-key-pass.value
    username           = "ac-obair"
}
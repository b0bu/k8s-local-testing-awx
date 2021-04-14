// terraform {
//   backend "azurerm" {
//     storage_account_name = "actfstate"
//     container_name       = ""
//     key                  = ""
//   }
// }

terraform {
  required_version = ">= 0.13"
  required_providers {
    awx = {
      source = "nolte/awx"
      version = "0.2.2"
    }
  }
}

provider "awx" {
  hostname = "http://192.168.88.223:8080"
  username = "admin"
  password = data.azurerm_key_vault_secret.awx-admin-pass.value
}

provider "azurerm" {
  version         = "=2.16.0"
  subscription_id = "0c0e5228-4139-4cc4-bfc0-8601fb17134a"
  features {}
}

data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "awx-test-keyvault" {
  name                = "awx-test-s38f893"
  resource_group_name = "awx-test"
}
data "azurerm_key_vault_secret" "awx-admin-pass" {
  name         = "awx-admin-pass"
  key_vault_id = data.azurerm_key_vault.awx-test-keyvault.id
}
data "azurerm_key_vault_secret" "ssh-key-pass" {
  name         = "ssh-key-pass"
  key_vault_id = data.azurerm_key_vault.awx-test-keyvault.id
}
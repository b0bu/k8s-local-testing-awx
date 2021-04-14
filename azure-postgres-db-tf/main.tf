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
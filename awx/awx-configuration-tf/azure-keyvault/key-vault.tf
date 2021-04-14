resource "azurerm_resource_group" "awx-test" {
  name     = "awx-test"
  location = "uksouth"
}

resource "azurerm_key_vault" "awx-test" {
  name                        = "awx-test-s38f893"
  location                    = azurerm_resource_group.awx-test.location
  resource_group_name         = azurerm_resource_group.awx-test.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "update",
      "get",
      "list",
      "delete",
      "encrypt",
      "purge",
      "restore",
      "sign",
      "verify"
    ]

    secret_permissions = [
      "set",
      "get",
      "list",
      "delete",
    ]

    storage_permissions = [
      "get",
    ]
  }
}
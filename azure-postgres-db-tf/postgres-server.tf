 resource "azurerm_resource_group" "awx-external-postgres" {
  name     = "awx-external-postgres"
  location = "uksouth"
}

resource "azurerm_postgresql_server" "awx-external-postgres" {
  name                = "awx-external-postgres"
  location            = azurerm_resource_group.awx-external-postgres.location
  resource_group_name = azurerm_resource_group.awx-external-postgres.name

  sku_name = "B_Gen5_1"

  storage_mb                       = 5120
  backup_retention_days            = 7
  geo_redundant_backup_enabled     = false
  auto_grow_enabled                = false

  administrator_login              = "psqladminun"
  administrator_login_password     = data.azurerm_key_vault_secret.awx-postgres-pass.value
  version                          = "11"
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_firewall_rule" "awx-external-postgres" {
  name                = "only-allow-me-test"
  resource_group_name = azurerm_resource_group.awx-external-postgres.name
  server_name         = azurerm_postgresql_server.awx-external-postgres.name
  start_ip_address    = "46.69.164.12"
  end_ip_address      = "46.69.164.12"
}
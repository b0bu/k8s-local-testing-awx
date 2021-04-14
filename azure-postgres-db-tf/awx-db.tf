resource "azurerm_postgresql_database" "awx" {
  name                = "awx"
  resource_group_name = azurerm_resource_group.awx-external-postgres.name
  server_name         = azurerm_postgresql_server.awx-external-postgres.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
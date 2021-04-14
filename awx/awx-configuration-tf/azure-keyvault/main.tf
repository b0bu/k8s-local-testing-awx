// terraform {
//   backend "azurerm" {
//     storage_account_name = "actfstate"
//     container_name       = ""
//     key                  = ""
//   }
// }

provider "azurerm" {
  version         = "=2.16.0"
  subscription_id = "0c0e5228-4139-4cc4-bfc0-8601fb17134a"
  features {}
}

data "azurerm_client_config" "current" {}
// terraform {
//   backend "azurerm" {
//     storage_account_name = ""
//     container_name       = ""
//     key                  = ""
//   }
// }

provider "kubernetes" {
  version        = "=1.11.3"
  config_context = "docker-desktop"
}

provider "helm" {
  version = "=1.2.3"
  kubernetes {
    config_context = "docker-desktop"
  }
}

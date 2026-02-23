data "azurerm_subscription" "primary" {}

data "azurerm_client_config" "example" {}

data "azurerm_locations" "available" {}

data "azurerm_virtual_machine_size" "example" {
  location = "West US"
}


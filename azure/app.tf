locals {
  app_services = [
    {
      kind = "Linux"
      sku = {
        tier = "Standard"
        size = "S1"
      }
    },
    {
      kind = "Windows"
      sku = {
        tier = "Basic"
        size = "B1"
      }
    }
  ]
}

resource "azurerm_app_service_plan" "example" {
  count               = length(local.app_services)
  name                = "${lower(local.app_services[count.index].kind)}-asp"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = local.app_services[count.index].kind
  reserved            = true

  sku {
    tier = local.app_services[count.index].sku.tier
    size = local.app_services[count.index].sku.size
  }
}

resource "azurerm_app_service" "example" {
  count               = length(local.app_services)
  name                = "${lower(local.app_services[count.index].kind)}-appservice"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example[count.index].id

  site_config {
    dotnet_framework_version = "v4.0"
    remote_debugging_enabled = true
    remote_debugging_version = "VS2015"
  }
}
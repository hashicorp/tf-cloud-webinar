terraform {
  required_version = "~> 0.12"
  backend "remote" {}
}

provider "azurerm" {
  version = "~> 1.32"
  client_id = var.client_id
  client_secret = var.client_secret
  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
}

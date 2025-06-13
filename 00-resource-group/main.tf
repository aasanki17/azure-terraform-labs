# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.32.0"
    }
  }
}

# Authentication details
provider "azurerm" {
  features { }
  subscription_id = "YOUR_SUBSCRIPTION_ID"
  client_id       = "YOUR_CLIENT_ID"
  client_secret   = "YOUR_CLIENT_SECRET"
  tenant_id       = "YOUR_TENANT_ID"
}

# Create a Azure resource group
resource "azurerm_resource_group" "resource-group" {
  name     = "terraform-rg"
  location = "West Europe"
}
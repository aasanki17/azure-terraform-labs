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
  name     = "terraformrg1"
  location = "West Europe"
}

# Create a Azure storage account
resource "azurerm_storage_account" "storage-account" {
  name                     = "terraformrgsa1"
  # This ensures Terraform waits for the resource group to be created before referencing it.
  # Without this implicit dependency, the plan may fail with:
  # Error: 404 (ResourceGroupNotFound): Resource group 'terraformrg1' could not be found
  resource_group_name = azurerm_resource_group.resource-group.name  # implicit dependency
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
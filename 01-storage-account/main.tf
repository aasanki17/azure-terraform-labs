# Terraform Configuration for Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.32.0"
    }
  }
}

# Authentication details
provider "azurerm" {
  features {}
  subscription_id = "YOUR_SUBSCRIPTION_ID"
  client_id       = "YOUR_CLIENT_ID"
  client_secret   = "YOUR_CLIENT_SECRET"
  tenant_id       = "YOUR_TENANT_ID"
}

# Create an Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = "terraformrg"
  location = "West Europe"

  tags = {
    environment = "dev"
    project     = "terraform-learning"
  }
}

# Create an Azure Storage Account
resource "azurerm_storage_account" "storage_account" {
  name = "terraformrgsa"
  # This ensures Terraform waits for the resource group to be created before referencing it.
  # Without this implicit dependency, the plan may fail with:
  # Error: 404 (ResourceGroupNotFound): Resource group 'terraformrg1' could not be found
  resource_group_name      = azurerm_resource_group.resource_group.name # implicit dependency
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

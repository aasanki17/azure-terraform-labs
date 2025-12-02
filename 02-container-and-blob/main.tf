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

}

# Create an Azure Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = "terraformrgsa"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  depends_on               = [azurerm_resource_group.resource_group] # explicit dependency

  tags = {
    environment = "dev"
    project     = "terraform-learning"
  }
}

# Create an Azure Storage Container
resource "azurerm_storage_container" "container" {
  name                  = "terraformcontainer"
  storage_account_id    = azurerm_storage_account.storage_account.id # implicit dependency
  container_access_type = "private"
}

# Create an Azure Storage Blob
resource "azurerm_storage_blob" "container_blob" {
  name                   = "terraformcontainerblob"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "main.tf" # Upload this file to the blob
}

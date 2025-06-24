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
  name     = "terraformrg2"
  location = "West Europe"
}

# Create a Azure storage account
resource "azurerm_storage_account" "storage-account" {
  name                     = "terraformrgsa2"
  resource_group_name      = "terraformrg2"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  depends_on = [ azurerm_resource_group.resource-group ] # explicit dependency
}

# Create a Azure container
resource "azurerm_storage_container" "container" {
  name                  = "terraformcontainer2"
  storage_account_id    = azurerm_storage_account.storage-account.id # implicit dependency
  container_access_type = "private"
}

# Create a Azure storage blob
resource "azurerm_storage_blob" "container-blob" {
  name                   = "terraformcontainerblob2"
  storage_account_name   = "terraformrgsa2"
  storage_container_name = "terraformcontainer2"
  type                   = "Block"
  source                 = "main.tf"
}
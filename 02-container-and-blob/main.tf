# Terraform Configuration for Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.32.0"
    }
  }
}

# Azure Provider Configuration
provider "azurerm" {
  features {}

  subscription_id = "YOUR_SUBSCRIPTION_ID"
  client_id       = "YOUR_CLIENT_ID"
  client_secret   = "YOUR_CLIENT_SECRET"
  tenant_id       = "YOUR_TENANT_ID"
}

# Generate a unique suffix to make the Storage Account globally unique
resource "random_string" "sa_suffix" {
  length  = 6
  upper   = false
  special = false
}

# Create an Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = "rg-aztf-02"
  location = "Southeast Asia"

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create an Azure Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = "staztf02${random_string.sa_suffix.result}"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = "Southeast Asia"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.resource_group] # explicit dependency

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create an Azure Storage Container
resource "azurerm_storage_container" "container" {
  name                  = "ct-aztf-02"
  storage_account_id    = azurerm_storage_account.storage_account.id # implicit dependency
  container_access_type = "private"
}

# Create an Azure Storage Blob
resource "azurerm_storage_blob" "sample_blob" {
  name                   = "sample-main.tf"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "main.tf" # Upload this file to the blob
}

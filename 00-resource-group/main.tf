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

# Create an Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = "rg-aztf-00"
  location = "Southeast Asia"

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

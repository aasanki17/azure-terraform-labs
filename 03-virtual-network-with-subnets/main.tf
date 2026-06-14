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

# Input variable for Resource Group name
variable "resource_group_name" {
  type    = string
  default = "rg-aztf-03"
}

# Input variable for Virtual Network name
variable "virtual_network_name" {
  type        = string
  default     = "vnet-aztf-03"
  description = "Name of the Azure Virtual Network"
}

# Local variable for Azure region
locals {
  location = "Southeast Asia"
}

# Create Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = local.location

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Virtual Network with two Subnets
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  location            = local.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name             = "snet-aztf-03-01"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "snet-aztf-03-02"
    address_prefixes = ["10.0.2.0/24"]
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

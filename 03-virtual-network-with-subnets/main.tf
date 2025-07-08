# Terraform Configuration for Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.32.0"
    }
  }
}

# Azure Provider Authentication (Manual configuration)
provider "azurerm" {
  features {}

  subscription_id = "YOUR_SUBSCRIPTION_ID"
  client_id       = "YOUR_CLIENT_ID"
  client_secret   = "YOUR_CLIENT_SECRET"
  tenant_id       = "YOUR_TENANT_ID"
}

# Input variable for resource group name (default value provided)
variable "var_resource_group" {
  type    = string
  default = "terraformrg"
}

# Input variable for virtual network name (must be provided)
variable "var_virtual_network" {
  type        = string
  description = "Name of the Azure Virtual Network to be created"
}

# Local variable for region
locals {
  location = "West Europe"
}

# Create Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.var_resource_group
  location = local.location

  tags = {
    environment = "dev"
    project     = "terraform-learning"
  }
}

# Create Azure Virtual Network with two Subnets
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.var_virtual_network
  location            = local.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name             = "terraformsubnet1"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "terraformsubnet2"
    address_prefixes = ["10.0.2.0/24"]
  }

  tags = {
    environment = "dev"
    project     = "terraform-learning"
  }
}

# Terraform Configuration for Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.32.0"
    }
  }
}

provider "azurerm" {
  features {}

  # Explicit subscription ensures Terraform deploys to the correct Azure subscription
  # Authentication is still performed using `az login`
  subscription_id = "YOUR_SUBSCRIPTION_ID"
}


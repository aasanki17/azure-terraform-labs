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
  subscription_id = "bad11f29-54cf-4014-9864-3301b426d2de"
}

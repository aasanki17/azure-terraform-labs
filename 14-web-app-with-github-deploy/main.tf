# Generate a unique suffix to make the Web App name globally unique
resource "random_string" "suffix_web_app" {
  length  = 6
  upper   = false
  special = false
}

# Create Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure App Service Plan (Windows)
resource "azurerm_service_plan" "service_plan" {
  name                = var.service_plan_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location

  sku_name = "B1"
  os_type  = "Windows"

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Windows Web App
resource "azurerm_windows_web_app" "web_app" {
  name                = "${var.web_app_name}-${random_string.suffix_web_app.result}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.service_plan.id

  site_config {
    always_on         = true
    use_32_bit_worker = true
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Register GitHub Personal Access Token in Azure
resource "azurerm_source_control_token" "github" {
  type  = "GitHub"
  token = var.github_token
}

# Configure GitHub-based deployment for the Web App
resource "azurerm_app_service_source_control" "source_control" {
  app_id   = azurerm_windows_web_app.web_app.id
  repo_url = var.github_repository_url
  branch   = "main"

  depends_on = [
    azurerm_source_control_token.github
  ]
}

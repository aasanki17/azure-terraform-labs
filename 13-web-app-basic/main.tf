# Generate a unique suffix to make the Web App name globally unique
resource "random_string" "suffix_web_app" {
  length  = 6
  upper   = false
  special = false
}

# Create Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.var_resource_group_name
  location = var.var_location
}

# Create Azure App Service Plan (Basic SKU)
resource "azurerm_service_plan" "service_plan" {
  name                = var.var_service_plan_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.var_location

  sku_name = "B1"
  os_type  = "Windows"
}

# Create Azure Windows Web App
resource "azurerm_windows_web_app" "web_app" {
  name                = "${var.var_web_app_name}-${random_string.suffix_web_app.result}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.var_location
  service_plan_id     = azurerm_service_plan.service_plan.id

  site_config {}
}

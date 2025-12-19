# Generate a unique suffix to make the SQL server name globally unique
resource "random_string" "suffix_sql_server" {
  length  = 6
  upper   = false
  special = false
}

# Create Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.var_resource_group_name
  location = var.var_location
}

# Create Azure SQL Server
resource "azurerm_mssql_server" "mssql_server" {
  name                         = "${var.var_mssql_server_name}-${random_string.suffix_sql_server.result}"
  resource_group_name          = azurerm_resource_group.resource_group.name
  location                     = var.var_location
  version                      = "12.0"
  administrator_login          = var.var_mssql_admin_username
  administrator_login_password = var.var_mssql_admin_password
}

# Create Azure SQL Database
resource "azurerm_mssql_database" "mssql_db" {
  name         = var.var_mssql_db_name
  server_id    = azurerm_mssql_server.mssql_server.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"

  # Prevent accidental deletion of database in production
  lifecycle {
    prevent_destroy = true
  }
}

# Prevent accidental deletion of database in production
resource "azurerm_mssql_firewall_rule" "firewall_rule" {
  name             = "AllowClientIP"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = var.var_allowed_ip
  end_ip_address   = var.var_allowed_ip
}

# Generate a unique suffix to make the SQL Server name globally unique
resource "random_string" "suffix_sql_server" {
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

# Create Azure SQL Server
resource "azurerm_mssql_server" "mssql_server" {
  name                         = "${var.mssql_server_name}-${random_string.suffix_sql_server.result}"
  resource_group_name          = azurerm_resource_group.resource_group.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.mssql_admin_username
  administrator_login_password = var.mssql_admin_password

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure SQL Database
resource "azurerm_mssql_database" "mssql_database" {
  name      = var.mssql_database_name
  server_id = azurerm_mssql_server.mssql_server.id

  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "Basic"

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create SQL Server Firewall Rule for Client Access
resource "azurerm_mssql_firewall_rule" "client_ip_firewall_rule" {
  name             = "allow-client-ip"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = var.allowed_client_ip
  end_ip_address   = var.allowed_client_ip
}

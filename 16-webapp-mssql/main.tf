# Current timestamp for SAS token generation
resource "time_static" "now" {}

# Generate a unique suffix to make the Storage Account globally unique
resource "random_string" "suffix_storage_acc" {
  length  = 6
  upper   = false
  special = false
}

# Generate a unique suffix to make the Web App name globally unique
resource "random_string" "suffix_web_app" {
  length  = 6
  upper   = false
  special = false
}

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

# Create an Azure Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.var_storage_account_name}${random_string.suffix_storage_acc.result}"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.var_location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# Create an Azure Storage Container
resource "azurerm_storage_container" "container" {
  name                  = var.var_storage_container_name
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

# Upload SQL Script  as Blob
resource "azurerm_storage_blob" "container_blob" {
  name                   = var.var_storage_blob_name
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "${path.module}/load-data.sql" # DB script file to load the data in the database
}

# Generate SAS Token to access the SQL script (24h validity)
data "azurerm_storage_account_sas" "storage_sas" {
  connection_string = azurerm_storage_account.storage_account.primary_connection_string
  https_only        = true
  signed_version    = "2022-11-02"
  start             = time_static.now.rfc3339
  expiry            = timeadd(time_static.now.rfc3339, "24h")

  resource_types {
    service   = false
    container = false
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
    tag     = false
    filter  = false
  }
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


}

# Allow Azure Services (Web App) to Access SQL Server
resource "azurerm_mssql_firewall_rule" "firewall_rule" {
  name             = "AllowClientIP"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = var.var_allowed_ip
  end_ip_address   = var.var_allowed_ip
}

resource "null_resource" "initialize_database" {
  depends_on = [
    azurerm_mssql_database.mssql_db
  ]

  provisioner "local-exec" {
    command = <<EOT
sqlcmd \
  -S ${azurerm_mssql_server.mssql_server.fully_qualified_domain_name} \
  -d ${var.var_mssql_db_name} \
  -U ${var.var_mssql_admin_username} \
  -P ${var.var_mssql_admin_password} \
  -i load-data.sql
EOT
  }
}

# Create Azure App Service Plan
resource "azurerm_service_plan" "service_plan" {
  name                = var.var_service_plan_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.var_location
  sku_name            = "B1"
  os_type             = "Windows"
}

# Create Azure Windows Web App
resource "azurerm_windows_web_app" "web_app" {
  name                = "${var.var_web_app_name}-${random_string.suffix_web_app.result}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.var_location
  service_plan_id     = azurerm_service_plan.service_plan.id

  site_config {
    always_on = true
  }

  # Injecting DB credentials in Web App
  connection_string {
    name  = "myDB"
    type  = "SQLServer"
    value = "Server=tcp=${azurerm_mssql_server.mssql_server.name}.database.windows.net;Database=${azurerm_mssql_database.mssql_db.name};User Id=${var.var_mssql_admin_username};Password=${var.var_mssql_admin_password};"
  }
}

# Register GitHub Personal Access Token in Azure
resource "azurerm_source_control_token" "github" {
  type  = "GitHub"
  token = var.var_github_token
}

# Deploy from GitHub
resource "azurerm_app_service_source_control" "source_control" {
  app_id   = azurerm_windows_web_app.web_app.id
  repo_url = var.var_github_repo_url
  branch   = var.var_github_branch
}

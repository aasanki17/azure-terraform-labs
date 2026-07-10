# Current timestamp for SAS token generation
resource "time_static" "now" {}

# Generate a unique suffix to make the Storage Account globally unique
resource "random_string" "suffix_storage_account" {
  length  = 6
  upper   = false
  special = false
}

# Generate a unique suffix to make the SQL Server name globally unique
resource "random_string" "suffix_sql_server" {
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

# Create Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.storage_account_name}${random_string.suffix_storage_account.result}"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Storage Container
resource "azurerm_storage_container" "storage_container" {
  name                  = var.storage_container_name
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

# Upload SQL script to Azure Blob Storage
resource "azurerm_storage_blob" "sql_script_blob" {
  name                   = var.storage_blob_name
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.storage_container.name
  type                   = "Block"
  source                 = "${path.module}/load-data.sql"
}

# Generate read-only SAS token for the SQL script blob
data "azurerm_storage_account_sas" "sql_script_sas" {
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

# Initialize Azure SQL Database using sqlcmd from the local machine
resource "null_resource" "initialize_database" {
  depends_on = [
    azurerm_mssql_database.mssql_database,
    azurerm_mssql_firewall_rule.client_ip_firewall_rule
  ]

  triggers = {
    sql_script_hash = filesha256("${path.module}/load-data.sql")
    database_id     = azurerm_mssql_database.mssql_database.id
  }

  provisioner "local-exec" {
    command = "sqlcmd -S \"$SQL_SERVER\" -d \"$SQL_DATABASE\" -U \"$SQL_USERNAME\" -P \"$SQL_PASSWORD\" -i \"${path.module}/load-data.sql\" -C -b"

    environment = {
      SQL_SERVER   = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
      SQL_DATABASE = azurerm_mssql_database.mssql_database.name
      SQL_USERNAME = var.mssql_admin_username
      SQL_PASSWORD = var.mssql_admin_password
    }
  }
}

# Create Azure App Service Plan
resource "azurerm_service_plan" "service_plan" {
  name                = var.service_plan_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  sku_name            = "B1"
  os_type             = "Windows"

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

  connection_string {
    name  = "SqlDatabase"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.mssql_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.mssql_database.name};Persist Security Info=False;User ID=${var.mssql_admin_username};Password=${var.mssql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
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
    azurerm_source_control_token.github,
    azurerm_windows_web_app.web_app
  ]
}

output "web_app_url" {
  description = "Default URL of the Azure Windows Web App"
  value       = "https://${azurerm_windows_web_app.web_app.default_hostname}"
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the Azure SQL Server"
  value       = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
}

output "storage_account_name" {
  description = "Name of the Azure Storage Account used to store the SQL script"
  value       = azurerm_storage_account.storage_account.name
}

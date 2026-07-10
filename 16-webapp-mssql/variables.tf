# Resource Configuration Variables
variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

# Storage Configuration Variables
variable "storage_account_name" {
  type        = string
  description = "Base name of the Azure Storage Account. A random suffix is added for global uniqueness"
}

variable "storage_container_name" {
  type        = string
  description = "Name of the Azure Storage Container used to store the SQL script"
}

variable "storage_blob_name" {
  type        = string
  description = "Name of the SQL script blob uploaded to Azure Storage"
}

# Azure SQL Configuration Variables
variable "mssql_server_name" {
  type        = string
  description = "Base name of the Azure SQL Server. A random suffix is added for global uniqueness"
}

variable "mssql_database_name" {
  type        = string
  description = "Name of the Azure SQL Database"
}

variable "mssql_admin_username" {
  type        = string
  description = "Administrator username for the Azure SQL Server"
}

variable "mssql_admin_password" {
  type        = string
  description = "Administrator password for the Azure SQL Server"
  sensitive   = true
}

variable "allowed_client_ip" {
  type        = string
  description = "Client public IP address allowed to access the Azure SQL Server"
}

# Web App Configuration Variables
variable "service_plan_name" {
  type        = string
  description = "Name of the Azure App Service Plan"
}

variable "web_app_name" {
  type        = string
  description = "Base name for the Azure Windows Web App. A random suffix is added for global uniqueness"
}

variable "github_repository_url" {
  type        = string
  description = "GitHub repository URL used as the deployment source for the Web App"
}

variable "github_token" {
  type        = string
  description = "GitHub Personal Access Token used by Azure App Service to access the repository"
  sensitive   = true
}

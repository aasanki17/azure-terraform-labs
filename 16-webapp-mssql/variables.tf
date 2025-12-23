# Azure Region and Resource Names
variable "var_location" {
  type        = string
  description = "Azure region"
}

variable "var_resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

# Storage Account Variables
variable "var_storage_account_name" {
  type        = string
  description = "Base name of the Storage Account (a random suffix is added for global uniqueness)"
}

variable "var_storage_container_name" {
  type        = string
  description = "Name of the Storage Container"
}

variable "var_storage_blob_name" {
  type        = string
  description = "Name of the Storage Blob"
}

# MSSQL Variables
variable "var_mssql_server_name" {
  type        = string
  description = "Base name of the Azure SQL Server (a random suffix is added for global uniqueness)"
}

variable "var_mssql_db_name" {
  type        = string
  description = "Name of the Azure SQL Database"
}

variable "var_mssql_admin_username" {
  type        = string
  description = "Administrator username for SQL Server"
}

variable "var_mssql_admin_password" {
  type        = string
  description = "Administrator password for SQL Server"
  sensitive   = true
}

variable "var_allowed_ip" {
  description = "Client public IP allowed to access Azure SQL Server"
  type        = string
}

# Web App Variables
variable "var_service_plan_name" {
  type        = string
  description = "Name of the Azure App Service plan"
}

variable "var_web_app_name" {
  type        = string
  description = "Base name for the Azure Windows Web App (a random suffix is added for global uniqueness)"
}

variable "var_github_token" {
  type        = string
  description = "GitHub Personal Access Token (PAT) used by Azure App Service to access the repository"
  sensitive   = true
}

variable "var_github_repo_url" {
  type        = string
  description = "GitHub repository URL used for Azure App Service deployment"
}

variable "var_github_branch" {
  type        = string
  description = "GitHub branch used for Azure App Service deployment"
  default     = "main"
}

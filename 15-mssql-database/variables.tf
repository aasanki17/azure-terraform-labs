# Resource Configuration Variables
variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

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

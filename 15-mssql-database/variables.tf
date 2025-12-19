# Resource Configuration Variables
variable "var_location" {
  type        = string
  description = "Azure region"
}

variable "var_resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

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
  description = "Administrator username for the SQL Server"
}

variable "var_mssql_admin_password" {
  type        = string
  description = "Administrator password for the SQL Server"
  sensitive   = true
}

variable "var_allowed_ip" {
  description = "Client IP allowed to access SQL Server"
  type        = string
}

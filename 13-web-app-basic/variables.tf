# Resource Configuration Variables
variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

variable "service_plan_name" {
  type        = string
  description = "Name of the Azure App Service Plan"
}

variable "web_app_name" {
  type        = string
  description = "Base name for the Azure Windows Web App. A random suffix is added for global uniqueness"
}

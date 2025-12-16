# Resource Configuration Variables
variable "var_location" {
  type        = string
  description = "Azure region"
}

variable "var_resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

variable "var_service_plan_name" {
  type        = string
  description = "Name of the Azure App Service plan"
}

variable "var_web_app_name" {
  type        = string
  description = "Base name for the Azure Windows Web App (must be globally unique after suffix)"
}

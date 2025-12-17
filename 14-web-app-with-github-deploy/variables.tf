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
  description = "Base name of the Azure Windows Web App (a random suffix is added for global uniqueness)"
}

variable "var_github_token" {
  type        = string
  description = "GitHub Personal Access Token (PAT) used by Azure App Service to access the repository"
  sensitive   = true
}

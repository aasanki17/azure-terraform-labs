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

variable "github_repository_url" {
  type        = string
  description = "GitHub repository URL used as the deployment source for the Web App"
}

variable "github_token" {
  type        = string
  description = "GitHub Personal Access Token used by Azure App Service to access the repository"
  sensitive   = true
}

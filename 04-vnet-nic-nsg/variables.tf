# Resource Configuration Variables
variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the Azure Virtual Network"
}

variable "subnet_name" {
  type        = string
  description = "Name of the Azure Subnet"
}

variable "public_ip_name" {
  type        = string
  description = "Name of the Azure Public IP Address"
}

variable "network_interface_name" {
  type        = string
  description = "Name of the Azure Network Interface"
}

variable "ip_configuration_name" {
  type        = string
  description = "Name of the IP configuration for the Network Interface"
}

variable "network_security_group_name" {
  type        = string
  description = "Name of the Azure Network Security Group"
}

variable "allowed_admin_cidr" {
  type        = string
  description = "Public IP range allowed for admin access, for example x.x.x.x/32"
}

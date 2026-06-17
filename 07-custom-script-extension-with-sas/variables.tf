# Resource Configuration Variables
variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

variable "storage_account_name" {
  type        = string
  description = "Base name of the Azure Storage Account. A random suffix is added for global uniqueness."
}

variable "storage_container_name" {
  type        = string
  description = "Name of the Azure Storage Container used to store the PowerShell script"
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

variable "windows_vm_name" {
  type        = string
  description = "Name of the Azure Windows Virtual Machine"
}

variable "os_disk_name" {
  type        = string
  description = "Name of the OS disk for the Windows Virtual Machine"
}

variable "vm_extension_name" {
  type        = string
  description = "Name of the Custom Script Extension used to install IIS"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the Windows Virtual Machine"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password for the Windows Virtual Machine"
}

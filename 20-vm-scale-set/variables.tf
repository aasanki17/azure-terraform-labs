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
  description = "Name of the Azure Storage Account used to store the IIS script"
}

variable "storage_container_name" {
  type        = string
  description = "Name of the Storage Container used for the IIS script"
}

variable "storage_blob_name" {
  type        = string
  description = "Name of the Storage Blob for the IIS PowerShell script"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the Azure Virtual Network"
}

variable "subnet_name" {
  type        = string
  description = "Name of the Azure Subnet"
}

variable "network_security_group_name" {
  type        = string
  description = "Name of the Azure Network Security Group"
}

variable "public_ip_name" {
  type        = string
  description = "Name of the Azure Public IP Address for the Load Balancer"
}

variable "load_balancer_name" {
  type        = string
  description = "Name of the Azure Load Balancer"
}

variable "frontend_ip_configuration_name" {
  type        = string
  description = "Name of the Load Balancer frontend IP configuration"
}

variable "backend_pool_name" {
  type        = string
  description = "Name of the Load Balancer backend address pool"
}

variable "health_probe_name" {
  type        = string
  description = "Name of the Load Balancer health probe"
}

variable "load_balancing_rule_name" {
  type        = string
  description = "Name of the Load Balancer rule"
}

variable "outbound_rule_name" {
  type        = string
  description = "Name of the Load Balancer outbound rule"
}

variable "vmss_name" {
  type        = string
  description = "Name of the Azure Windows Virtual Machine Scale Set"
}

variable "vmss_network_interface_name" {
  type        = string
  description = "Name of the VMSS network interface configuration"
}

variable "vmss_ip_configuration_name" {
  type        = string
  description = "Name of the VMSS IP configuration"
}

variable "vmss_extension_name" {
  type        = string
  description = "Name of the VMSS Custom Script Extension"
}

variable "autoscale_setting_name" {
  type        = string
  description = "Name of the Azure Monitor autoscale setting"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM Scale Set"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password for the VM Scale Set"
}

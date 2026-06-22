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

variable "linux_vm_name" {
  type        = string
  description = "Name of the Azure Linux Virtual Machine"
}

variable "os_disk_name" {
  type        = string
  description = "Name of the OS disk for the Linux Virtual Machine"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the Linux Virtual Machine"
}

variable "public_ssh_key_path" {
  type        = string
  description = "Path to the public SSH key used for Linux VM authentication"
}

# Retrieve current Azure AD tenant and Object ID
data "azurerm_client_config" "current" {}

# Generate a unique suffix for globally unique Key Vault names
resource "random_string" "unique_key_vault" {
  length  = 5
  upper   = false
  special = false
}

# Create Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.var_resource_group_name
  location = var.var_location

  tags = {
    environment = "terraform-lab"
    module      = "08-key-vault"
  }
}

# Create Azure Virtual Network
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.var_virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = var.var_location
  resource_group_name = azurerm_resource_group.resource_group.name
}

# Create Azure Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.var_subnet_name
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Azure Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = var.var_public_ip_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.var_location
  allocation_method   = "Static"
}

# Create Azure Network Interface (NIC)
resource "azurerm_network_interface" "network_interface" {
  name                = var.var_nic_name
  location            = var.var_location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "${var.var_nic_name}_ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Create Azure Key Vault to store secrets like VM admin password securely
resource "azurerm_key_vault" "key_vault" {
  name                       = "${var.var_key_vault_name}${random_string.unique_key_vault.result}"
  location                   = var.var_location
  resource_group_name        = azurerm_resource_group.resource_group.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

# Create Secret in Key Vault for VM admin password
resource "azurerm_key_vault_secret" "key_vault_secret" {
  name         = "terraformkeysecret"
  value        = var.var_admin_password
  key_vault_id = azurerm_key_vault.key_vault.id
}

# Create Windows Virtual Machine with password pulled from Key Vault
resource "azurerm_windows_virtual_machine" "virtual_machine" {
  name                = var.var_windows_vm_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.var_location
  size                = "Standard_D2s_v3"
  admin_username      = var.var_admin_username
  admin_password      = azurerm_key_vault_secret.key_vault_secret.value
  network_interface_ids = [
    azurerm_network_interface.network_interface.id
  ]

  os_disk {
    name                 = "${var.var_windows_vm_name}_os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}


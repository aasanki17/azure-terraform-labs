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
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Virtual Network
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Azure Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Network Interface (NIC)
resource "azurerm_network_interface" "network_interface" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Key Vault to store secrets like VM admin password securely
resource "azurerm_key_vault" "key_vault" {
  name                       = "${var.key_vault_name}${random_string.unique_key_vault.result}"
  location                   = var.location
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
      "List",
      "Delete",
      "Purge",
      "Recover"
    ]
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Secret in Key Vault for VM admin password
resource "azurerm_key_vault_secret" "key_vault_secret" {
  name         = var.key_vault_secret_name
  value        = var.admin_password
  key_vault_id = azurerm_key_vault.key_vault.id
}

# Create Windows Virtual Machine with password pulled from Key Vault
resource "azurerm_windows_virtual_machine" "virtual_machine" {
  name                = var.windows_vm_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = azurerm_key_vault_secret.key_vault_secret.value
  network_interface_ids = [
    azurerm_network_interface.network_interface.id
  ]

  os_disk {
    name                 = var.os_disk_name
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}


# Current timestamp for SAS token generation
resource "time_static" "now" {}

# Generate a unique suffix to make the Storage Account globally unique
resource "random_string" "suffix_storage_acc" {
  length  = 6
  upper   = false
  special = false
}

# Create an Azure Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.var_resource_group_name
  location = var.var_location
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

# Create Azure Network Interface
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

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.var_windows_vm_name}_nsg"
  location            = var.var_location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create an Azure Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.var_storage_account_name}${random_string.unique_storage_acc.result}"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.var_location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# Create a Blob container
resource "azurerm_storage_container" "blob_container" {
  name                  = var.var_storage_container_name
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

# Upload PowerShell script to blob
resource "azurerm_storage_blob" "storage_blob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.blob_container.name
  type                   = "Block"
  source                 = "${path.module}/IIS_Config.ps1"
}

# Generate SAS Token to access the script
data "azurerm_storage_account_sas" "storage_sas" {
  connection_string = azurerm_storage_account.storage_account.primary_connection_string
  https_only        = true
  signed_version    = "2022-11-02"
  start             = time_static.now.rfc3339
  expiry            = timeadd(time_static.now.rfc3339, "24h")

  resource_types {
    service   = false
    container = false
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}

# Create Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "virtual_machine" {
  name                = var.var_windows_vm_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.var_location
  size                = "Standard_D2s_v3"
  admin_username      = var.var_admin_username
  admin_password      = var.var_admin_password
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

# Use Custom Script Extension to install IIS on VM via uploaded script
resource "azurerm_virtual_machine_extension" "vm_extension" {
  name                 = "terraformvmextension"
  virtual_machine_id   = azurerm_windows_virtual_machine.virtual_machine.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    fileUris = [
      "${azurerm_storage_blob.storage_blob.url}?${data.azurerm_storage_account_sas.storage_sas.sas}"
    ]
  })

  protected_settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -File IIS_Config.ps1"
  })
}

# Output the Public IP of the Windows VM
output "vm_public_ip_address" {
  description = "Public IP of the Windows VM"
  value       = azurerm_public_ip.public_ip.ip_address
}

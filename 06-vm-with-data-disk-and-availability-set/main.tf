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

# Create Azure Network Interface
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

# Create Availability Set
resource "azurerm_availability_set" "vm_availability_set" {
  name                         = var.availability_set_name
  location                     = var.location
  resource_group_name          = azurerm_resource_group.resource_group.name
  platform_update_domain_count = 5
  platform_fault_domain_count  = 2

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "virtual_machine" {
  name                = var.windows_vm_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  availability_set_id = azurerm_availability_set.vm_availability_set.id
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

# Create Managed Data Disk
resource "azurerm_managed_disk" "managed_disk" {
  name                 = var.data_disk_name
  location             = var.location
  resource_group_name  = azurerm_resource_group.resource_group.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Attach Data Disk to VM
resource "azurerm_virtual_machine_data_disk_attachment" "vm_data_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.managed_disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.virtual_machine.id
  lun                = "10"
  caching            = "ReadWrite"
}

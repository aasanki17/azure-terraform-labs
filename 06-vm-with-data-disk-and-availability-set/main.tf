# Create Azure Resource Group
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

#Create Availability Set
resource "azurerm_availability_set" "vm_availability_set" {
  name                         = "${var.var_windows_vm_name}_as"
  location                     = var.var_location
  resource_group_name          = azurerm_resource_group.resource_group.name
  platform_update_domain_count = 5
  platform_fault_domain_count  = 3

}

# Create Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "virtual_machine" {
  name                = var.var_windows_vm_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.var_location
  size                = "Standard_D2s_v3"
  admin_username      = var.var_admin_username
  admin_password      = var.var_admin_password
  availability_set_id = azurerm_availability_set.vm_availability_set.id
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

# Create Managed Data Disk
resource "azurerm_managed_disk" "managed_disk" {
  name                 = "${var.var_windows_vm_name}_disk"
  location             = var.var_location
  resource_group_name  = azurerm_resource_group.resource_group.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

# Attach Data Disk to VM
resource "azurerm_virtual_machine_data_disk_attachment" "vm_data_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.managed_disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.virtual_machine.id
  lun                = "10"
  caching            = "ReadWrite"
}

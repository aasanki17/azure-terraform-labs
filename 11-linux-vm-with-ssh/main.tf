# Read SSH Public Key (Terraform expands "~" using pathexpand)
data "local_file" "ssh_key" {
  filename = pathexpand(var.var_public_ssh_key_path)
}

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

# Create Azure Network Security Group (NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = var.var_nsg_name
  location            = var.var_location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create Azure Linux Virtual Machine using SSH authentication
resource "azurerm_linux_virtual_machine" "virtual_machine" {
  name                = var.var_linux_vm_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.var_location
  size                = "Standard_D2ads_v6"
  admin_username      = var.var_admin_username
  network_interface_ids = [
    azurerm_network_interface.network_interface.id
  ]

  admin_ssh_key {
    username   = var.var_admin_username
    public_key = data.local_file.ssh_key.content
  }

  os_disk {
    name                 = "${var.var_linux_vm_name}_os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}


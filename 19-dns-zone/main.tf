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
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["10.0.0.0/16"]

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

# Create Azure Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create Azure Availability Set for backend VMs
resource "azurerm_availability_set" "availability_set" {
  name                         = var.availability_set_name
  location                     = var.location
  resource_group_name          = azurerm_resource_group.resource_group.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Public IP for Load Balancer
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Load Balancer
resource "azurerm_lb" "load_balancer" {
  name                = var.load_balancer_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Load Balancer Backend Address Pool
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = var.backend_pool_name
  loadbalancer_id = azurerm_lb.load_balancer.id
}

# Create Load Balancer Health Probe
resource "azurerm_lb_probe" "health_probe" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = var.health_probe_name
  protocol        = "Tcp"
  port            = 80
}

# Create Load Balancer Rule
resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = var.load_balancing_rule_name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.health_probe.id
}

# Create Azure Network Interface for VM1
resource "azurerm_network_interface" "network_interface_1" {
  name                = var.network_interface_name_1
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = var.ip_configuration_name_1
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create Azure Network Interface for VM2
resource "azurerm_network_interface" "network_interface_2" {
  name                = var.network_interface_name_2
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = var.ip_configuration_name_2
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Associate VM1 Network Interface with Load Balancer Backend Pool
resource "azurerm_network_interface_backend_address_pool_association" "nic_1_backend_pool_assoc" {
  network_interface_id    = azurerm_network_interface.network_interface_1.id
  ip_configuration_name   = var.ip_configuration_name_1
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

# Associate VM2 Network Interface with Load Balancer Backend Pool
resource "azurerm_network_interface_backend_address_pool_association" "nic_2_backend_pool_assoc" {
  network_interface_id    = azurerm_network_interface.network_interface_2.id
  ip_configuration_name   = var.ip_configuration_name_2
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

# Create Azure Windows Virtual Machine 1
resource "azurerm_windows_virtual_machine" "virtual_machine_1" {
  name                  = var.windows_vm_name_1
  resource_group_name   = azurerm_resource_group.resource_group.name
  location              = var.location
  size                  = "Standard_D2s_v3"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  availability_set_id   = azurerm_availability_set.availability_set.id
  network_interface_ids = [azurerm_network_interface.network_interface_1.id]

  os_disk {
    name                 = var.os_disk_name_1
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

# Create Azure Windows Virtual Machine 2
resource "azurerm_windows_virtual_machine" "virtual_machine_2" {
  name                  = var.windows_vm_name_2
  resource_group_name   = azurerm_resource_group.resource_group.name
  location              = var.location
  size                  = "Standard_D2s_v3"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  availability_set_id   = azurerm_availability_set.availability_set.id
  network_interface_ids = [azurerm_network_interface.network_interface_2.id]

  os_disk {
    name                 = var.os_disk_name_2
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

# Install IIS on VM1 using Custom Script Extension
resource "azurerm_virtual_machine_extension" "vm_extension_1" {
  name                 = var.vm_extension_name_1
  virtual_machine_id   = azurerm_windows_virtual_machine.virtual_machine_1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -Command \"& { Install-WindowsFeature -Name Web-Server -IncludeManagementTools; Start-Service W3SVC; Set-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value ('This is the server ' + $env:COMPUTERNAME + '!') }\""
  })
}

# Install IIS on VM2 using Custom Script Extension
resource "azurerm_virtual_machine_extension" "vm_extension_2" {
  name                 = var.vm_extension_name_2
  virtual_machine_id   = azurerm_windows_virtual_machine.virtual_machine_2.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -Command \"& { Install-WindowsFeature -Name Web-Server -IncludeManagementTools; Start-Service W3SVC; Set-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value ('This is the server ' + $env:COMPUTERNAME + '!') }\""
  })
}

# Create Azure DNS Zone
resource "azurerm_dns_zone" "dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

# Create DNS A Record pointing to Load Balancer Public IP
resource "azurerm_dns_a_record" "dns_a_record" {
  name                = var.dns_record_name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.resource_group.name
  ttl                 = var.dns_record_ttl
  records             = [azurerm_public_ip.public_ip.ip_address]

  tags = {
    environment = "dev"
    project     = "azure-terraform-labs"
  }
}

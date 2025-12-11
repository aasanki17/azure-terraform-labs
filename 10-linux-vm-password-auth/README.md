# 10 - Azure Linux Virtual Machine

## Objective

Use Terraform to provision a **Linux Virtual Machine** in Azure, along with all necessary network infrastructure components:

- Virtual Network (VNet)
- Subnet
- Public IP
- Network Interface (NIC)
- Network Security Group (NSG) with SSH rule
- NSG → Subnet Association

It uses password-based authentication for Linux VM login. Configuration is clean and modular, using `variables.tf` for dynamic values and Azure CLI for authentication.

## Prerequisites

- An active Azure Subscription
- Azure CLI installed and authenticated (`az login`)
- Terraform installed
- An optional `terraform.tfvars` file (excluded via `.gitignore`) for custom values

## Azure Authentication (az login)

Instead of hardcoding sensitive credentials (`client_id`, `client_secret`, etc.), this project uses the Azure CLI session:

```bash
az login
```

This allows Terraform to authenticate securely without passing client_id, client_secret, or tenant_id.

## Variable Configuration

This project uses two files to manage variables:

`variables.tf` — defines expected inputs
`terraform.tfvars` — supplies input values

Example terraform.tfvars:

```hcl
var_location             = "West Europe"
var_resource_group_name  = "terraformrg"
var_virtual_network_name = "terraformvn"
var_subnet_name          = "terraformsubnet"
var_public_ip_name       = "terraformpublicip"
var_nic_name             = "terraformnic"
var_nsg_name             = "terraformnsg"
var_linux_vm_name        = "terraformvm"
var_admin_username       = "adminuser"
var_admin_password       = "AzureVMpwd@123"
```

Terraform will automatically detect and use this file if it's named terraform.tfvars.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

To deploy the Linux VM with password-based authentication:

```bash
terraform apply -var-file="terraform.tfvars"
```

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Validate the Deployment

1. Go to the Azure Portal > Resource Group

2. Confirm that:

   - The Virtual Network, Subnet, Public IP, NIC are created
   - The Linux VM is deployed and in "Running" state
   - The NSG is created and associated with the Subnet
   - NSG has an inbound Allow SSH (22) rule

3. Verify SSH access from your Mac:

```bash
ssh <admin_username>@<public_ip>
```

4. Validate VM is reachable internally:

   - Run ping google.com (to verify outbound internet)

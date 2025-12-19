# 06 - Azure VM with Data Disk and Availability Set

## Objective

Use Terraform to create a **Windows Virtual Machine** in Azure with an attached **data disk** and **availability set** for high availability. This setup includes all required networking components:

- Virtual Network
- Subnet
- Public IP
- Network Interface (NIC)

The configuration is modular and clean, using `variables.tf` for dynamic values and `provider.tf` for authentication.

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
var_windows_vm_name      = "terraformvm"
var_admin_username       = "adminuser"
var_admin_password       = "<YOUR_STRONG_PASSWORD>"
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

To deploy a Windows VM in Azure with an attached data disk and configure it for high availability using an availability set:

```bash
terraform apply -var-file="terraform.tfvars"
```

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

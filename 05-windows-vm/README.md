# 05 - Azure Windows Virtual Machine

## Objective

Use Terraform to provision a **Windows Virtual Machine** in Azure, along with all necessary network infrastructure components: - Virtual Network

- Subnet
- Network Interface (NIC)
- Public IP

This configuration builds on the previous networking setup in [04-vnet-nic-nsg](../04-vnet-nic-nsg/). It is modular, uses `variables.tf` for dynamic values, and leverages secure authentication via Azure CLI (`az login`).

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

Deploy the Windows VM and networking components:

```bash
terraform apply -var-file="terraform.tfvars"
```

Destroy all created resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

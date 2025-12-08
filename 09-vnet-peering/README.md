# 09 - Azure Virtual Network (VNet) Peering

## Objective

Use Terraform to deploy **two Virtual Networks (VNets)** in Azure and establish **bidirectional peering** between them.

Peering enables:

- Private IP communication across VNets
- Low latency, high-bandwidth interconnect
- No public internet dependency

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
var_location              = "West Europe"
var_resource_group_name   = "terraformrg"
var_virtual_network_name1 = "terraformvn1"
var_virtual_network_name2 = "terraformvn2"
var_vnetpeer1to2          = "terraformpeer1to2"
var_vnetpeer2to1          = "terraformpeer2to1"
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

To provision both Virtual Networks and configure bidirectional VNet peering:

```bash
terraform apply -var-file="terraform.tfvars"
```

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Validate the Deployment

1. After deployment:

2. Go to Azure Portal → Virtual Networks

3. Open each VNet → Peerings

4. Confirm:

   - Peering state: Connected
   - Virtual network access: Enabled
   - Forwarded traffic: Enabled

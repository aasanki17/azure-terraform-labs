# 09 - Azure Virtual Network Peering

## Objective

Deploy two **Azure Virtual Networks** using Terraform and configure **bidirectional VNet peering** between them.

VNet peering allows resources in separate Virtual Networks to communicate privately using Azure’s internal network instead of the public internet.

This setup includes:

- Resource Group
- Virtual Network 1
- Virtual Network 2
- VNet 1 to VNet 2 peering
- VNet 2 to VNet 1 peering

## Prerequisites

- An active Azure Subscription
- Azure CLI installed and authenticated (`az login`)
- Terraform installed
- A local `terraform.tfvars` file created from `terraform.tfvars.example`

## Azure Authentication (az login)

Instead of hardcoding sensitive credentials (`client_id`, `client_secret`, etc.), this project uses the Azure CLI session:

```bash
az login
```

This allows Terraform to authenticate securely without passing `client_id`, `client_secret`, or `tenant_id` in the provider block.

## Configuration Files

This folder uses separate Terraform files to keep the configuration organized:

- `variables.tf` — defines the input variables used by the configuration
- `terraform.tfvars.example` — provides a safe template for required variable values
- `terraform.tfvars` — stores local values used during deployment and is excluded from GitHub

Create a local `terraform.tfvars` file from `terraform.tfvars.example`, then update the values if needed.

The actual `terraform.tfvars` file is not committed because it can contain environment-specific values.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

Deploy the Virtual Networks and configure bidirectional VNet peering:

```bash
terraform apply -var-file="terraform.tfvars"
```

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Validation

After deployment, verify the following in the Azure Portal:

1. Open the Resource Group created by this lab.

2. Confirm that the following resources exist:
   - Virtual Network 1
   - Virtual Network 2

3. Open Virtual Network 1:
   - Go to Peerings
   - Confirm that `peer-aztf-09-vnet-1-to-vnet-2` exists
   - Confirm that the peering state is Connected

4. Open Virtual Network 2:
   - Go to Peerings
   - Confirm that `peer-aztf-09-vnet-2-to-vnet-1` exists
   - Confirm that the peering state is Connected

5. Confirm that virtual network access is enabled for both peering connections.

## Security Note

VNet peering enables private communication between Virtual Networks over Azure’s backbone network. It does not require public IP addresses or public internet access between the peered networks.

This module demonstrates how to connect two Azure Virtual Networks securely using bidirectional VNet peering.

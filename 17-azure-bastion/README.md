# 17 - Azure Bastion with Windows Virtual Machine

## Objective

Deploy an Azure Windows Virtual Machine in a private subnet and access it securely using Azure Bastion.

This module demonstrates how Azure Bastion provides browser-based RDP access to a Windows Virtual Machine without assigning a public IP address to the VM.

This setup includes:

- Resource Group
- Virtual Network
- Subnet for the Windows Virtual Machine
- Dedicated Azure Bastion Subnet
- Standard Public IP used by Azure Bastion
- Network Security Group for subnet access control
- Network Interface for the Windows Virtual Machine
- Windows Virtual Machine without public IP
- Azure Bastion Host for secure browser-based access

## Azure Authentication

This project uses Azure CLI authentication:

```bash
az login
```

Terraform uses the active Azure CLI session, so no Azure client secret is stored in the Terraform files.

## Prerequisites

- Active Azure subscription
- Azure CLI installed and authenticated
- Terraform installed
- Local terraform.tfvars file created from terraform.tfvars.example

## Configuration Files

- variables.tf — defines input variables
- terraform.tfvars.example — safe sample variable file
- terraform.tfvars — local values file, excluded from GitHub

## How It Works

1. Terraform creates a Resource Group.
2. Terraform creates a Virtual Network.
3. Terraform creates a subnet for the Windows Virtual Machine.
4. Terraform creates a dedicated subnet for Azure Bastion.
5. Terraform creates a Standard Public IP for Azure Bastion.
6. Terraform creates a Network Security Group.
7. Terraform allows RDP traffic to the VM only from the Bastion subnet.
8. Terraform creates a Network Interface for the Windows Virtual Machine.
9. Terraform creates a Windows Virtual Machine without a public IP address.
10. Terraform creates an Azure Bastion Host.
11. The VM can be accessed securely through Azure Portal using Bastion.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview the deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

Deploy the resources:

```bash
terraform apply -var-file="terraform.tfvars"
```

Destroy the resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Validation

After deployment, check these resources in Azure Portal:

1. Resource Group
2. Virtual Network
3. VM subnet
4. Azure Bastion subnet
5. Standard Public IP
6. Network Security Group
7. Network Interface
8. Windows Virtual Machine
9. Azure Bastion Host

To connect to the VM:

1. Go to Azure Portal.
2. Open the Windows Virtual Machine.
3. Select Connect.
4. Select Bastion.
5. Enter the admin username and admin password.
6. Connect through the browser.

The Windows Virtual Machine should not have a public IP address.

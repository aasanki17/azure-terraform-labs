# 18 - Azure Load Balancer

## Objective

Deploy an Azure Load Balancer that distributes HTTP traffic across two Windows Virtual Machines running IIS.

This module demonstrates how a public Load Balancer can route traffic to multiple backend virtual machines in the same subnet.

This setup includes:

- Resource Group
- Virtual Network
- Subnet
- Network Security Group with inbound HTTP access
- Storage Account for hosting the IIS configuration script
- Blob Container and Blob for the PowerShell script
- Public IP for the Load Balancer
- Azure Load Balancer
- Frontend IP configuration
- Backend address pool
- Health probe
- Load balancing rule for HTTP traffic on port 80
- Two Network Interfaces
- Two Windows Virtual Machines without public IP addresses
- Custom Script Extensions to install IIS on both VMs

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
- outputs.tf — displays the Load Balancer public IP address
- terraform.tfvars.example — safe sample variable file
- terraform.tfvars — local values file, excluded from GitHub
- IIS_Config.ps1 — installs IIS and creates the test webpage on each Windows VM

## How It Works

1. Terraform creates a Resource Group.
2. Terraform creates a Virtual Network.
3. Terraform creates a subnet for the backend virtual machines.
4. Terraform creates a Network Security Group.
5. Terraform allows inbound HTTP traffic on port 80.
6. Terraform creates a Storage Account and private Blob Container.
7. Terraform uploads the IIS PowerShell script to Blob Storage.
8. Terraform generates a temporary SAS token so the VMs can access the script.
9. Terraform creates a Standard Public IP for the Load Balancer.
10. Terraform creates an Azure Load Balancer.
11. Terraform creates a frontend IP configuration for the Load Balancer.
12. Terraform creates a backend address pool.
13. Terraform creates a health probe on port 80.
14. Terraform creates a load balancing rule for HTTP traffic.
15. Terraform creates two Network Interfaces.
16. Terraform associates both Network Interfaces with the Load Balancer backend pool.
17. Terraform creates two Windows Virtual Machines.
18. Terraform runs the IIS PowerShell script on both VMs using Custom Script Extensions.
19. HTTP traffic sent to the Load Balancer public IP is distributed across the two backend VMs.

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

View the Load Balancer public IP:

```bash
terraform output
```

Destroy the resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Validation

After deployment, check these resources in Azure Portal:

1. Resource Group
2. Virtual Network
3. Subnet
4. Network Security Group
5. Storage Account
6. Blob Container
7. Uploaded IIS PowerShell script
8. Public IP address
9. Load Balancer
10. Backend address pool
11. Health probe
12. Load balancing rule
13. Network Interfaces
14. Windows Virtual Machines
15. Custom Script Extensions

To test the Load Balancer:

1. Copy the Load Balancer public IP from Terraform output or Azure Portal.
2. Open the public IP address in a browser using HTTP.
3. Refresh the page multiple times.

You should see traffic served by the backend virtual machines.

Expected responses:

```text
This is the server vm-aztf-18-win1!
This is the server vm-aztf-18-win2!
```

The response may not switch on every refresh immediately because load balancing behavior depends on the active TCP connection and browser behavior.

## Security Notes

- Backend virtual machines are not assigned public IP addresses.
- The Load Balancer is the only public entry point for HTTP traffic.
- The Storage Container remains private, and the IIS script is accessed through a temporary SAS token.
- The admin password is kept only in the local terraform.tfvars file, which is excluded from GitHub.

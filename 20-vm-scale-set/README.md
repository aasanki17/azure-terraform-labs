# 20 - Azure Virtual Machine Scale Set with Load Balancer and Autoscaling

## Objective

Deploy a Windows Virtual Machine Scale Set behind an Azure Load Balancer and configure CPU-based autoscaling using Azure Monitor.

This lab demonstrates how VM Scale Sets can provide scalable backend compute capacity while a Load Balancer distributes HTTP traffic across the VMSS instances.

This setup includes:

- Resource Group
- Virtual Network
- Subnet
- Network Security Group with inbound HTTP access
- Storage Account for the IIS setup script
- Private Blob Container
- Blob upload for the PowerShell IIS script
- SAS token for secure script access
- Standard Public IP for the Load Balancer
- Standard Azure Load Balancer
- Frontend IP configuration
- Backend address pool
- Health probe
- Load balancing rule for HTTP traffic on port 80
- Outbound rule for VMSS internet access
- Windows Virtual Machine Scale Set with two instances
- Custom Script Extension to install IIS on VMSS instances
- Azure Monitor autoscale setting with CPU-based scale-out and scale-in rules

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
- IIS_Config.ps1 file available in this folder

## Configuration Files

- variables.tf — defines input variables
- outputs.tf — displays the Load Balancer public IP
- terraform.tfvars.example — safe sample variable file
- terraform.tfvars — local values file, excluded from GitHub
- IIS_Config.ps1 — PowerShell script used to install IIS on VMSS instances

## How It Works

1. Terraform creates a Resource Group.
2. Terraform creates a Virtual Network and subnet.
3. Terraform creates a Network Security Group allowing inbound HTTP traffic on port 80.
4. Terraform creates a Storage Account and private Blob Container.
5. Terraform uploads the IIS PowerShell script to Blob Storage.
6. Terraform generates a temporary SAS token so VMSS instances can access the script.
7. Terraform creates a Standard Public IP and Standard Load Balancer.
8. Terraform creates a backend address pool, health probe, HTTP rule, and outbound rule.
9. Terraform creates a Windows Virtual Machine Scale Set with two instances.
10. Terraform associates the VMSS network configuration with the Load Balancer backend pool.
11. Terraform installs IIS on the VMSS instances using a Custom Script Extension.
12. Terraform creates Azure Monitor autoscale rules based on average CPU usage.
13. HTTP traffic sent to the Load Balancer public IP is routed to one of the VMSS instances.

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

View the output:

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
2. Virtual Network and subnet
3. Network Security Group
4. Storage Account
5. Blob Container
6. Uploaded IIS PowerShell script
7. Public IP address
8. Load Balancer
9. Backend address pool
10. Health probe
11. Load balancing rule
12. Outbound rule
13. Virtual Machine Scale Set
14. VMSS instances
15. VMSS Custom Script Extension
16. Azure Monitor autoscale setting

To test the Load Balancer:

```bash
terraform output load_balancer_public_ip
```

Open the Load Balancer public IP in a browser using HTTP, or test it from the terminal:

```bash
curl http://<load-balancer-public-ip>
```

Expected response:

```text
This is the server <vmss-instance-hostname>!
```

Refresh the browser or run the curl command multiple times to observe responses from VMSS instances.

To inspect autoscale settings, open the VM Scale Set in Azure Portal and check the scaling options under:

```text
Availability + scale
```

The autoscale profile should show:

```text
Minimum instances: 1
Default instances: 2
Maximum instances: 4
Scale out when average CPU > 75%
Scale in when average CPU < 25%
```

If the autoscale setting is not visible in the Resource Group list or VMSS scaling page, verify it from Azure CLI:

```bash
az monitor autoscale list \
  --resource-group rg-aztf-20 \
  --query "[].{name:name, enabled:enabled, target:targetResourceUri}" \
  --output table
```

## Security Notes

- VMSS instances are not assigned individual public IP addresses.
- The Load Balancer is the public entry point for HTTP traffic.
- The IIS script is stored in a private Blob Container.
- The VMSS accesses the IIS script using a temporary SAS token.
- The admin password is kept only in the local terraform.tfvars file, which is excluded from GitHub.

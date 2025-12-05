# 07 - Custom Script Extension with SAS to Install IIS

## Objective

Use Terraform to deploy a **Windows Virtual Machine** in Azure and install **IIS** using a PowerShell script stored in **Azure Blob Storage**. The VM downloads the script using a **SAS token** (valid for 24 hours from the time of deployment) and installs IIS via the **Custom Script Extension**.

This setup includes all required networking resources:

- Virtual Network
- Subnet
- Public IP
- Network Interface (NIC)
- Storage Account
- Blob Container
- NSG and NSG-to-Subnet Association

## Prerequisites

- An active Azure Subscription
- Azure CLI installed and authenticated (`az login`)
- Terraform installed
- An optional `terraform.tfvars` file (excluded via `.gitignore`) for custom values
- A valid PowerShell file (`IIS_Config.ps1`) placed in the same folder as your Terraform configuration

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
var_location               = "West Europe"
var_resource_group_name    = "terraformrg"
var_storage_account_name   = "terraformsa"
var_storage_container_name = "terraformcontainer"
var_virtual_network_name   = "terraformvn"
var_subnet_name            = "terraformsubnet"
var_public_ip_name         = "terraformpublicip"
var_nic_name               = "terraformnic"
var_windows_vm_name        = "terraformvm"
var_admin_username         = "adminuser"
var_admin_password         = "AzureVMpwd@123"
```

Terraform will automatically detect and use this file if it's named terraform.tfvars.

## - Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

To deploy a Windows VM and install IIS using a PowerShell script via SAS token and Custom Script Extension:

```bash
terraform apply -var-file="terraform.tfvars"
```

After applying, you can get the public IP using:

```bash
terraform output
```

Use this IP to RDP into the VM or access the IIS welcome page.

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Validate the Deployment

1. Go to the Azure Portal > Resource Group

2. Confirm that:

   - The Storage Account and Blob Container are created
   - The PowerShell script is uploaded to the blob
   - The Windows VM is deployed and running

3. Verify IIS from inside the VM:
   RDP into the VM and check that IIS is installed

4. Verify IIS externally:
   Use the following command to retrieve the public IP:

```bash
terraform output
```

Then access the IIS welcome page in your browser:

`http://<PUBLIC_IP>`

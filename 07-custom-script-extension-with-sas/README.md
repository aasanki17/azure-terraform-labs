# 07 - Custom Script Extension with SAS to Install IIS

## Objective

Deploy an **Azure Windows Virtual Machine** using Terraform and install **IIS** with a PowerShell script stored in Azure Blob Storage.

This folder builds on the Windows VM deployment from `05-windows-vm` and introduces automated post-deployment configuration using the Azure Custom Script Extension. The PowerShell script is uploaded to a private blob container and accessed by the VM through a short-lived SAS token.

This setup includes:

- Virtual Network
- Subnet
- Public IP
- Network Interface
- Network Security Group
- Storage Account
- Blob Container
- PowerShell script upload
- SAS token generation
- Windows Virtual Machine
- Custom Script Extension

## Azure Authentication (az login)

Instead of hardcoding sensitive credentials (`client_id`, `client_secret`, etc.), this project uses the Azure CLI session:

```bash
az login
```

This allows Terraform to authenticate securely without passing `client_id`, `client_secret`, or `tenant_id` in the provider block.

## Prerequisites

- An active Azure Subscription
- Azure CLI installed and authenticated (`az login`)
- Terraform installed
- A local `terraform.tfvars` file created from `terraform.tfvars.example`
- The PowerShell file `IIS_Config.ps1` available in this folder

## Configuration Files

This folder uses separate Terraform files to keep the configuration organized:

- `variables.tf` — defines the input variables used by the configuration
- `terraform.tfvars.example` — provides a safe template for required variable values
- `terraform.tfvars` — stores local values used during deployment and is excluded from GitHub
- `outputs.tf` — displays the public IP address used to access the IIS welcome page
- `IIS_Config.ps1` — installs and starts IIS on the Windows VM

Create a local `terraform.tfvars` file from `terraform.tfvars.example`, then replace `admin_password` with a strong password that meets Azure VM password requirements.

The actual `terraform.tfvars` file is not committed because it can contain sensitive values such as the VM administrator password.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

Deploy the Windows VM and install IIS using the Custom Script Extension:

```bash
terraform apply -var-file="terraform.tfvars"
```

After deployment, get the public IP address:

```bash
terraform output
```

Use this IP to access the IIS welcome page in your browser.

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Validation

After deployment, verify the following in the Azure Portal:

1. Open the Resource Group created by this lab.

2. Confirm that the following resources exist:
   - Storage Account
   - Blob Container
   - Public IP
   - Network Interface
   - Network Security Group
   - Windows Virtual Machine

3. Open the Blob Container and confirm that `IIS_Config.ps1` was uploaded.

4. Open the Windows Virtual Machine and confirm that the Custom Script Extension completed successfully.

5. Retrieve the public IP address:

```bash
terraform output
```

6. Open the IIS welcome page in your browser:

```text
http://<PUBLIC_IP>
```

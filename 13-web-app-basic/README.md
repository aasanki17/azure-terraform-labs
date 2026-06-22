# 13 - Azure Basic Windows Web App

## Objective

Deploy a basic **Azure Windows Web App** using Terraform.

This module creates a simple Azure App Service environment using a Windows App Service Plan and a Windows Web App. It demonstrates deployment of a Platform-as-a-Service (PaaS) web application in Azure with minimal configuration.

This setup includes:

- Resource Group
- Azure App Service Plan
- Azure Windows Web App
- Random suffix for globally unique Web App naming

The Web App uses the default Azure App Service landing page. No custom application code is deployed in this lab.

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

## Configuration Files

This folder uses separate Terraform files to keep the configuration organized:

- `variables.tf` — defines the input variables used by the configuration
- `terraform.tfvars.example` — provides a safe template for required variable values
- `terraform.tfvars` — stores local values used during deployment and is excluded from GitHub

Create a local `terraform.tfvars` file from `terraform.tfvars.example`, then update values if needed.

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

Deploy the Windows Web App:

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
   - App Service Plan
   - App Service / Web App

3. Open the App Service Plan.

4. Confirm:
   - Operating System: Windows
   - Pricing tier / SKU: B1

5. Open the Web App.

6. Confirm:
   - Status: Running
   - App Service Plan is linked correctly
   - Default domain is available

7. Copy the default domain or open the Web App URL.

The URL will look similar to:

```text
https://app-aztf-13-<random-suffix>.azurewebsites.net
```

You should see the default Azure App Service landing page.

# 13 - Azure Web App (Windows)

## Objective

Provision a basic **Azure Web App (Windows)** using Terraform, including:

- Azure Resource Group
- Azure App Service Plan
- Azure Windows Web App

This setup demonstrates how to launch an App Service **Platform-as-a-Service (PaaS)** web app with minimal configuration.

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
var_location            = "West Europe"
var_resource_group_name = "terraformrg"
var_service_plan_name   = "terraformserviceplan"
var_web_app_name        = "terraformwebapp"
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

To deploy the Azure Web App (Windows):

```bash
terraform apply -var-file="terraform.tfvars"
```

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## After Deployment

After deployment, retrieve the Web App URL from Terraform output or Azure Portal.

Access the application in your browser:

`https://<web-app-name>.azurewebsites.net`

You should see the default Azure App Service landing page.

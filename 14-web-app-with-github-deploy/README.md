# 14 - Azure Web App (Windows) with GitHub Deployment

## Objective

Provision a **Windows-based Azure Web App** using Terraform, with automated GitHub deployment. Includes:

- Azure Resource Group
- Azure App Service Plan
- Azure Windows Web App
- GitHub repository integration using App Service Source Control
- Secure handling of GitHub Personal Access Tokens (PAT)

This setup demonstrates how to launch an App Service **Platform-as-a-Service (PaaS)** web app with minimal configuration.

## Prerequisites

- An active Azure Subscription
- Azure CLI installed and authenticated (`az login`)
- Terraform installed
- An optional `terraform.tfvars` file (excluded via `.gitignore`) for custom values
- GitHub Personal Access Token with `repo` scope

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
var_github_token        = "<YOUR_GITHUB_PAT>"
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

To deploy the Azure Web App (Windows) with Github deploy:

```bash
terraform apply -var-file="terraform.tfvars"
```

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## After Deployment

Once deployment completes successfully, the Web App will be available at:

`https://<web-app-name>.azurewebsites.net`

You can also manage and monitor the application through the Azure Portal under App Services.

# 14 - Azure Windows Web App with GitHub Deployment

## Objective

Deploy an **Azure Windows Web App** using Terraform and configure GitHub-based source control deployment.

This module creates a Windows App Service Plan, a Windows Web App, registers a GitHub Personal Access Token with Azure App Service, and connects the Web App to a GitHub repository for deployment.

This setup includes:

- Resource Group
- Azure App Service Plan
- Azure Windows Web App

This lab builds on the basic Web App deployment from folder `13-web-app-basic` by adding GitHub-based deployment.

## Azure Authentication (az login)

Instead of hardcoding sensitive Azure credentials (`client_id`, `client_secret`, etc.), this project uses the Azure CLI session:

```bash
az login
```

This allows Terraform to authenticate securely without passing `client_id`, `client_secret`, or `tenant_id` in the provider block.

## Prerequisites

- An active Azure Subscription
- Azure CLI installed and authenticated (`az login`)
- Terraform installed
- A GitHub repository containing deployable application code
- A GitHub Personal Access Token
- A local `terraform.tfvars` file created from `terraform.tfvars.example`

## GitHub Personal Access Token

This lab uses a GitHub Personal Access Token so Azure App Service can access the GitHub repository.

The token is passed to Terraform using the sensitive variable:

```hcl
github_token = "<YOUR_GITHUB_PERSONAL_ACCESS_TOKEN>"
```

The real token should be stored only in your local `terraform.tfvars` file.

## Configuration Files

This folder uses separate Terraform files to keep the configuration organized:

- `variables.tf` — defines the input variables used by the configuration
- `terraform.tfvars.example` — provides a safe template for required variable values
- `terraform.tfvars` — stores local values used during deployment and is excluded from GitHub

Create a local `terraform.tfvars` file from `terraform.tfvars.example`, then update the GitHub token if needed.

The actual `terraform.tfvars` file is not committed because it contains a sensitive GitHub token.

For production workloads, use the least required GitHub token permissions, rotate tokens regularly, and consider more secure deployment approaches such as GitHub Actions with federated credentials or managed identity where appropriate.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

Deploy the Windows Web App with GitHub-based deployment:

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

7. Open the Web App URL.

The URL will look similar to:

```text
https://app-aztf-14-<random-suffix>.azurewebsites.net
```

8. Go to:

```text
Web App → Deployment Center
```

9. Confirm that GitHub source control is connected.

10. Confirm:
    - Source: GitHub
    - Repository: the repository configured in `github_repository_url`
    - Branch: `main`

11. Open the Web App URL in a browser and confirm that the application from the GitHub repository is deployed.

# 16 - Azure Web App with SQL Database and Blob hosted Execution

## Objective

Provision a **Windows Azure Web App** connected to an **Azure SQL Database**, and automatically load data into the database via a **PowerShell script** file stored in **Azure Blob Storage**.

This setup demonstrates how to:

- Use Terraform to manage Azure infrastructure.
- Automate database setup via a script hosted in blob storage.
- Securely inject connection strings and credentials into the web app.
- Link GitHub source control for CI/CD-style deployment.

## Prerequisites

- An active Azure Subscription
- Azure CLI installed and authenticated (`az login`)
- Terraform installed
- GitHub repository containing this project
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
`terraform.tfvars.example` — shows sample values without exposing real secrets or personal configuration

Example terraform.tfvars:

```hcl
var_location               = "West Europe"
var_resource_group_name    = "terraformrg"
var_storage_account_name   = "terraformsa"
var_storage_container_name = "terraformcontainer"
var_storage_blob_name      = "terraformcontainerblob"
var_mssql_server_name      = "terraformsqlserver"
var_mssql_db_name          = "terraformsqldb"
var_mssql_admin_username   = "sqladminuser"
var_mssql_admin_password   = "A-Strong-Pa$$w0rd"
var_allowed_ip             = "x.x.x.x"
var_service_plan_name      = "terraformserviceplan"
var_web_app_name           = "terraformwebapp"
var_github_token           = "<YOUR_GITHUB_PAT>"
var_github_repo_url       = "https://github.com/your-username/your-repo"
var_github_branch         = "main"
```

Terraform will automatically detect and use this file if it's named terraform.tfvars.

The actual `terraform.tfvars` file is not committed because it can contain sensitive or personal values. A `terraform.tfvars.example` file is included to show which values are required.

## How It Works

1. SQL Script Upload: load-data.sql is uploaded to a private blob container.
2. SAS Token: A 24-hour temporary SAS token is generated to securely access the blob.
3. Web App:
   - Uses `powershell|7` runtime.
   - Executes `load-db.ps1` on startup.
   - Downloads SQL script via SAS URL.
   - Executes it using `sqlcmd` to populate the database.
4. Database:
   - Secure credentials passed via environment variables and connection_string.
   - `prevent_destroy = true` ensures production safety.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

To deploy a Web App connected to an Azure SQL Database and populate it using a script from Blob Storage:

```bash
terraform apply -var-file="terraform.tfvars"
```

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## After Deployment

1. Once deployed, visit your live Web App at:

`https://<your-web-app-name>.azurewebsites.net`

2. Validate database:
   - Connect via VS Code (MSSQL extension)
   - Confirm Inventory table exists and is populated

3. Monitor execution:

Azure Portal → Web App → Log stream

## Outputs

After deployment, Terraform shows:

- `web_app_url` - URL of the deployed Azure Web App
- `sql_server_fqdn` - SQL Server fully qualified domain name
- `storage_account_name` - Storage account used for the SQL script

## Security Note

This lab passes SQL connection details to the Web App using app settings and a connection string. This is acceptable for a learning lab, but in a real production setup I would use stronger secret management, such as Key Vault references or managed identity where possible.

The SQL firewall rule is controlled through a variable, so the client IP is not hardcoded in the Terraform file.

The SAS token generated for the SQL script is temporary and read-only.

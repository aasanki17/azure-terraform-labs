# 15 - Azure MSSQL Database

## Objective

Provision a **fully managed Azure SQL Database (PaaS)** using Terraform. This project includes:

- SQL Server
- SQL Database
- SQL Server firewall rule for controlled access

This setup demonstrates how to deploy a secure, scalable, and production-ready relational database without managing virtual machines.

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
var_location             = "North Europe"
var_resource_group_name  = "terraformrg"
var_mssql_server_name    = "terraformsqlserver"
var_mssql_db_name        = "terraformsqldb"
var_mssql_admin_username = "sqladminuser"
var_mssql_admin_password = "<YOUR_STRONG_PASSWORD>"
var_allowed_ip           = "<YOUR_IP_ADDRESS>"
```

Terraform will automatically detect and use this file if it's named terraform.tfvars.

## Firewall

A firewall rule is required to allow connections to the SQL Server. Without a firewall rule, all connections are blocked by default.

_Current Configuration_

The example here allows access from a specific IP address (<YOUR_IP_ADDRESS>).

```bash
start_ip_address = "0.0.0.0"
end_ip_address   = "0.0.0.0"
```

_Allowing Azure Services (Optional)_

To allow Azure services (e.g., Web Apps, Azure DevOps) to connect:

```bash
start_ip_address = "0.0.0.0"
end_ip_address   = "0.0.0.0"
```

Note: 0.0.0.0 does not mean “open to the internet”. It allows only trusted Azure services.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

To deploy the MSSQL Database:

```bash
terraform apply -var-file="terraform.tfvars"
```

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

If destruction fails, ensure the prevent_destroy lifecycle block is removed from the database resource.

## Validate the Deployment

1. Go to the Azure Portal > Resource Group
   Confirm that:

   - The SQL Server exists
   - The SQL Database exists under the server

2. Test Database Connectivity
   Use Visual Studio Code with the MSSQL extension.

   i) Open Command Palette:

   ```
   Cmd + Shift + P → MS SQL: Connect
   ```

   ii) Provide:

   - Server: <sql-server-name>.database.windows.net
   - Authentication: SQL Login
   - Username: SQL admin username
   - Database: SQL database name

   Successful output confirms connectivity.

   iv) Firewall Validation

   - Ensure your client IP is allowed in SQL Server firewall rules
   - Firewall changes may take a few minutes to apply

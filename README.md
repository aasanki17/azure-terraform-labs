# Terraform (Azure)

This repository contains hands-on Terraform projects for deploying Microsoft Azure infrastructure.

Each folder is a **standalone Terraform project** that demonstrates a specific Azure service or Infrastructure as Code concept.

## Tools

- [Visual Studio Code](https://code.visualstudio.com/)
- Terraform CLI
- Azure CLI (`az`)
- HashiCorp Terraform extension for VS Code
- Azure Terraform extension for VS Code

## Installation on macOS

### Step 1: Install Homebrew

Install Homebrew by running this command in the macOS terminal:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installation, configure your PATH (Homebrew will show the commands).

Follow the on-screen instructions to complete the setup.

### Step 2: Install Azure CLI (Required for Terraform Authentication)

```bash
brew update && brew install azure-cli
```

Verify installation:

```bash
az version
```

### Step 3: Install Terraform

Follow the official Terraform installation guide for macOS:  
[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli)

Or, install it directly using Homebrew:

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform -v
```

## Basic Terraform Commands

| Command             | Description                                          |
| ------------------- | ---------------------------------------------------- |
| `terraform init`    | Initialize a new or existing Terraform configuration |
| `terraform plan`    | Show the execution plan before applying changes      |
| `terraform apply`   | Apply the changes to reach the desired state         |
| `terraform destroy` | Destroy the infrastructure managed by Terraform      |

## Authentication Approach

The first few folders show Service Principal authentication fields as placeholders for understanding the manual authentication setup.

Later folders use Azure CLI authentication with `az login` for local Terraform development.

No real credentials are committed in this repository.

## Repository Structure

Each folder below is a self-contained Terraform project.  
Run `terraform init`, `terraform plan`, and `terraform apply` inside that specific folder.

```
azure-terraform-labs/
├── 00-resource-group/                         # Create an Azure Resource Group
│   ├── main.tf
│   └── README.md
│
├── 01-storage-account/                        # Create an Azure Storage Account
│   ├── main.tf
│   └── README.md
│
├── 02-container-and-blob/                     # Create a Blob Container and Upload a Blob
│   ├── main.tf
│   └── README.md
│
├── 03-virtual-network-with-subnets/           # Create a Virtual Network with Subnets
│   ├── main.tf
│   └── README.md
│
├── 04-vnet-nic-nsg/                           # Create VNet, Subnet, NIC, Public IP, NSG, and subnet association
│   ├── provider.tf
│   ├── variables.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   └── README.md
│
├── 05-windows-vm/                             # Deploy a Windows Virtual Machine
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   └── README.md
│
├── 06-vm-with-data-disk-and-availability-set/ # Add a Data Disk and Availability Set to a VM
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   └── README.md
│
├── 07-custom-script-extension-with-sas/       # Install IIS Using Custom Script Extension and SAS Token
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   ├── IIS_Config.ps1
│   └── README.md
│
├── 08-key-vault-vm-password/                  # Store VM Password Securely in Azure Key Vault
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   └── README.md
│
├── 09-vnet-peering/                           # Configure VNet Peering Between Two VNets
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   └── README.md
│
├── 10-linux-vm-password-auth/                 # Deploy a Linux VM Using Password Authentication
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   └── README.md
│
├── 11-linux-vm-with-ssh/                      # Deploy a Linux VM Using SSH Key Authentication
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   └── README.md
│
├── 12-linux-vm-with-cloudinit/                # Configure a Linux VM at Boot Using cloud-init (NGINX)
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   ├── cloud-init.yaml
│   └── README.md
│
├── 13-web-app-basic/                          # Deploy a Basic Azure Windows Web App
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   └── README.md
│
├── 14-web-app-with-github-deploy/             # Deploy a Web App with GitHub-based Continuous Deployment
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   └── README.md
│
├── 15-mssql-database/                         # Provision Azure SQL Server and Database with firewall rule
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   └── README.md
│
├── 16-webapp-mssql/                           # Web App executes a Blob-hosted SQL script to populate Azure SQL Database
│   ├── provider.tf
│   ├── variables.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   ├── load-data.sql
│   ├── load-db.ps1
│   └── README.md
│
├── .gitignore
└── README.md                                  # Root Documentation for the Repository
```

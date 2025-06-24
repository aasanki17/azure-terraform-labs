# Terraform (Azure)

This repository documents my learning journey with Terraform on Microsoft Azure.

## Tools
- [Visual Studio Code](https://code.visualstudio.com/)
- Terraform CLI
- HashiCorp Terraform extension for VS Code
- Azure Terraform extension for VS Code

## Installation on macOS

### Step 1: Install Homebrew
Install Homebrew by running this command in the macOS terminal:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Follow the on-screen instructions to complete the setup.

### Step 2: Install Terraform
Follow the official Terraform installation guide for macOS:  
[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli)

Or, install it directly using Homebrew:
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform -v
```

## Basic Terraform Commands

| Command | Description |
|---------|-------------|
| `terraform init` | Initialize a new or existing Terraform configuration |
| `terraform plan` | Show the execution plan before applying changes |
| `terraform apply` | Applies the changes to reach the desired state |
| `terraform destroy` | Destroys the infrastructure managed by Terraform |

## Repository Structure

```
Terraform/
├── 00-resource-group/        # Create a resource group
│   ├── main.tf
│   └── README.md
├── 01-storage-account/       # Create a storage account
│   ├── main.tf
│   └── README.md
├── 02-container-and-blob/    # Create a container and blob
│   ├── main.tf
│   └── README.md
├── .gitignore
└── README.md
```

## About Me

I’m Ankita Shrivastava, a beginner Cloud Engineer actively learning Azure and Terraform with a focus on Cloud Infrastructure and DevOps roles. This repository is a part of my hands-on Azure learning journey. Let’s connect on [LinkedIn](https://www.linkedin.com/in/ankita-shrivastava17/)!
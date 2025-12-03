# Terraform (Azure)

This repository documents my learning journey with Terraform on Microsoft Azure.
It contains fully working, **standalone Terraform projects**, each demonstrating a specific Azure service or IaC concept.

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
| `terraform apply`   | Applies the changes to reach the desired state       |
| `terraform destroy` | Destroys the infrastructure managed by Terraform     |

## Repository Structure

Each folder below is a self-contained Terraform project.  
Run `terraform init`, `terraform plan`, and `terraform apply` inside that specific folder.

```
Terraform/
├── 00-resource-group/                      # Create a resource group
│   ├── main.tf
│   └── README.md
├── 01-storage-account/                     # Create a storage account
│   ├── main.tf
│   └── README.md
├── 02-container-and-blob/                  # Create a container and blob
│   ├── main.tf
│   └── README.md
├── 03-virtual-network-with-subnets/        # Create virtual network with subnets
│   ├── main.tf
│   └── README.md
├── 04-vnet-nic-nsg/                        # Create VNet, Subnet, NIC, Public IP, and NSG
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   └── README.md
├── 05-windows-vm/                          # Deploy a Windows Virtual Machine
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   └── README.md
├── .gitignore
└── README.md                                # This file
```

## About Me

I’m Ankita Shrivastava, a beginner Cloud Engineer actively learning Azure and Terraform with a focus on Cloud Infrastructure and DevOps roles.
This repository is a part of my hands-on Azure learning journey.

Let’s connect on [LinkedIn](https://www.linkedin.com/in/ankita-shrivastava17/)!

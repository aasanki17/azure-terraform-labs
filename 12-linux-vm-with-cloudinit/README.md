# 12 - Azure Linux Virtual Machine with cloud-init

## Objective

Deploy an **Azure Linux Virtual Machine** using Terraform and configure it with **cloud-init** to automatically install and start **NGINX** during first boot.

This module creates the networking components required for the Linux VM, configures inbound SSH and HTTP access, and uses cloud-init to bootstrap the VM with NGINX.

This setup includes:

- Resource Group
- Virtual Network
- Subnet
- Public IP
- Network Interface
- Network Security Group
- NSG to Subnet Association
- Linux Virtual Machine
- cloud-init configuration
- NGINX installation

It uses SSH key-based authentication for Linux VM login. The public key is read from a local file and added to the VM during provisioning. The private key remains on your local machine and is not committed to GitHub.

cloud-init is used to install and start NGINX automatically when the VM boots for the first time.

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
- A valid SSH key pair
- A local `terraform.tfvars` file created from `terraform.tfvars.example`

## SSH Key Setup

SSH key authentication uses a key pair:

- The public key is used by Azure to configure VM access
- The private key stays securely on your local machine

Generate an SSH key pair:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/aztf-12-linux
```

When prompted for a passphrase, press Enter twice to leave it empty for this lab.

This creates:

- Private key: `~/.ssh/aztf-12-linux`
- Public key: `~/.ssh/aztf-12-linux.pub`

Check that both files were created:

```bash
ls -l ~/.ssh/aztf-12-linux*
```

You should see both key files:

- `aztf-12-linux`
- `aztf-12-linux.pub`

Secure the private key permissions:

```bash
chmod 600 ~/.ssh/aztf-12-linux
```

Use the public key path in your local `terraform.tfvars` file:

```hcl
public_ssh_key_path = "~/.ssh/aztf-12-linux.pub"
```

## cloud-init Configuration

cloud-init is used to configure the Linux VM during first boot.

The cloud-init configuration is stored in:

```text
cloud-init.yaml
```

The file installs NGINX, enables the NGINX service, and starts it automatically.

```yaml
#cloud-config
package_update: true
package_upgrade: true

packages:
  - nginx

runcmd:
  - systemctl enable nginx
  - systemctl start nginx
```

Terraform reads this file and passes it to the VM using the `custom_data` argument.

Azure requires `custom_data` to be base64-encoded, so the Terraform configuration uses:

```hcl
custom_data = base64encode(local.cloud_init_data)
```

## Configuration Files

This folder uses separate Terraform files to keep the configuration organized:

- `variables.tf` — defines the input variables used by the configuration
- `terraform.tfvars.example` — provides a safe template for required variable values
- `terraform.tfvars` — stores local values used during deployment and is excluded from GitHub
- `cloud-init.yaml` — defines the first-boot VM configuration used to install NGINX

Create a local `terraform.tfvars` file from `terraform.tfvars.example`, then update the SSH public key path if needed.

The actual `terraform.tfvars` file is not committed because it can contain environment-specific values such as local SSH key paths.

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Preview configuration before deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

Deploy the Linux VM with cloud-init:

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
   - Virtual Network
   - Subnet
   - Public IP
   - Network Interface
   - Network Security Group
   - Linux Virtual Machine

3. Open the Network Security Group.

4. Go to:
   - Inbound security rules

5. Confirm that the SSH rule exists:
   - allow-ssh

6. Confirm that the SSH rule allows:
   - Protocol: TCP
   - Port: 22
   - Direction: Inbound
   - Access: Allow

7. Confirm that the HTTP rule exists:
   - allow-http

8. Confirm that the HTTP rule allows:
   - Protocol: TCP
   - Port: 80
   - Direction: Inbound
   - Access: Allow

9. Open the Linux Virtual Machine and confirm that it is running.

10. Copy the Public IP address.

11. Connect from your terminal using the private key:

```bash
ssh -i ~/.ssh/aztf-12-linux aztfadmin@<PUBLIC_IP_ADDRESS>
```

12. After logging in, verify that NGINX is installed:

```bash
nginx -v
```

13. Verify that the NGINX service is running:

```bash
systemctl status nginx
```

14. Test NGINX from your local terminal or browser:

```bash
curl http://<PUBLIC_IP_ADDRESS>
```

You should see the default NGINX welcome page HTML.

## Security Note

This lab uses SSH key-based authentication, which is more secure than password-based authentication.

The private SSH key stays on your local machine and should never be committed to GitHub. Only the public key is referenced by Terraform and added to the Linux VM.

The NSG allows SSH traffic on port 22 and HTTP traffic on port 80. For a production setup, SSH access should be restricted to a trusted source IP address instead of being open broadly.

cloud-init runs during the VM's first boot. If the cloud-init configuration changes later, the VM may need to be recreated for the first-boot configuration to run again.

This module demonstrates Linux VM deployment with SSH key-based authentication and automated NGINX installation using cloud-init.

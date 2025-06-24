# 02 - Container and Blob

## Objective
Use Terraform to create a Storage Container and upload a Blob with explicit and implicit dependency in Microsoft Azure by manually configuring the Azure provider with authentication values.

## Prerequisites
- Terraform setup and Azure provider configured
- An existing resource group and storage account

## Steps Performed 

To create a Storage Container and upload a Blob:

```bash
terraform init
terraform plan
terraform apply
```

File created:
terraformcontainerblob2

To destroy all resources:

```bash
terraform destroy
```
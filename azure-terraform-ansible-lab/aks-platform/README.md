# Azure AKS + ACR Terraform Lab

A practical Azure cloud infrastructure lab that provisions an Azure Kubernetes Service (AKS) cluster and Azure Container Registry (ACR) using Terraform.

## Architecture

```text
Terraform
   ↓
Azure Resource Group
   ├── Azure Container Registry (ACR)
   │      ↓
   │   stores container images
   │
   └── Azure Kubernetes Service (AKS)
          ↓
       Kubernetes workloads

AKS kubelet identity
        ↓
    AcrPull role
        ↓
        ACR
```

## What this project creates

- Azure Resource Group
- Azure Container Registry (Basic SKU)
- Azure Kubernetes Service cluster
- Single AKS system node pool
- System-assigned managed identity
- `AcrPull` RBAC role assignment allowing AKS to pull images from ACR

## Terraform resources

The configuration uses the AzureRM provider and defines:

```text
azurerm_resource_group
azurerm_container_registry
azurerm_kubernetes_cluster
azurerm_role_assignment
```

## Key configuration

### Azure Container Registry

The registry is configured with:

```text
SKU: Basic
Admin account: Disabled
```

Disabling the ACR admin account avoids relying on a shared registry username/password.

### Azure Kubernetes Service

The AKS cluster uses:

```text
Node pool: system
Node count: 1
VM size: Standard_B2s
Identity: SystemAssigned
```

The kubelet identity receives the `AcrPull` role on the registry so Kubernetes nodes can retrieve container images directly from ACR.

## Terraform workflow

Initialise the working directory:

```bash
terraform init
```

Format the configuration:

```bash
terraform fmt
```

Validate the Terraform configuration:

```bash
terraform validate
```

Preview the proposed Azure changes:

```bash
terraform plan
```

For a reviewed deployment, save the plan:

```bash
terraform plan -out=aks.tfplan
```

Apply the saved plan:

```bash
terraform apply aks.tfplan
```

## Outputs

After deployment Terraform returns the ACR login server and AKS cluster name:

```text
acr_login_server = "nachodevopsacr.azurecr.io"
aks_name         = "aks-devops-lab"
```

## Verification

List the Azure resources created in the resource group:

```bash
az resource list \
  --resource-group rg-devops-aks-lab \
  --output table
```

Expected high-level resources include:

```text
Azure Container Registry
Azure Kubernetes Service
```

AKS also creates and manages a separate `MC_...` resource group containing supporting infrastructure such as the node Virtual Machine Scale Set, networking and load-balancing resources.

## Cleanup

AKS worker nodes and ACR can incur Azure charges while they exist. After completing the lab, remove the environment using Terraform:

```bash
terraform destroy
```

Using Terraform for cleanup keeps the Terraform state aligned with the Azure environment.

## Security and source control

Terraform state, saved plan files and local provider data are excluded from Git because they can contain environment-specific or sensitive information.

Typical exclusions include:

```text
.terraform/
*.tfstate
*.tfstate.*
*.tfplan
```

## Concepts demonstrated

- Infrastructure as Code with Terraform
- Azure resource provisioning
- Managed Kubernetes with AKS
- Container registry architecture with ACR
- Azure managed identities
- Azure RBAC
- AKS-to-ACR integration
- Terraform plan/apply workflow
- Reproducible cloud infrastructure
- Controlled infrastructure teardown

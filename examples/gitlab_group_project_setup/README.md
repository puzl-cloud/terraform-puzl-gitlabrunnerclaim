# Managing GitLab Resources and integration with puzl.cloud

## Introduction

This example provides a comprehensive setup for automating the creation and management of GitLab resources and integrating them with puzl.cloud services.

## Prerequisites

- Terraform v1.3.0 or higher.
- A GitLab instance (either gitlab.com or a self-hosted GitLab).

## Usage

1. Update the `main.tf` file with your specific details, such as the GitLab URL and desired namespace.
2. Set `KUBE_HOST`,`KUBE_TOKEN` and `TF_VAR_gitlab_access_token` enviroment varibale.
3. Initialize the Terraform environment:

```bash
terraform init
terraform plan
```

5. Apply the Terraform configuration:

```bash
terraform apply
```

## Cleanup

To remove the deployed resources, run:

```bash
terraform destroy
```
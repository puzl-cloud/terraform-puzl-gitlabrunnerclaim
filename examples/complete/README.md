# Example Usage of GitLab Runner Claim Module

This example demonstrates how to use the GitLab Runner Claim Terraform module with GitLab Pipelines Integration Module and Gitlab Access Token Module.

## Usage

### Apply

1. Create credetials in your Puzl  https://gitlab-pipelines.puzl.cloud/dashboard
2. Update the `main.tf` file with your specific details, such as GitLab settings and your Puzl root namespace name.
3. Set `KUBE_HOST`,`KUBE_TOKEN` and `TF_VAR_gitlab_access_token` enviroment varibale.
4. Initialize the Terraform environment:

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

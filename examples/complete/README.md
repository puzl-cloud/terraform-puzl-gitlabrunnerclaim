# Example Usage of puzl.cloud module for GitLab Runner Claim

This example demonstrates how to use Puzl's modules for GitLab runner orchestration utilizing GitLab access token management within the integration.

## Usage

### Apply

1. Create credetials in your Puzl dashboard https://gitlab-pipelines.puzl.cloud/dashboard
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

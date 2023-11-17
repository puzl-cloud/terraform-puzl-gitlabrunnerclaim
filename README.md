# Puzl GitLab Runner Claim Terraform module

## Overview

This Terraform module is a way of requesting a GitLab runner within [GitLab Pipelines Service](https://gitlab-pipelines.puzl.cloud) by Puzl. 

`GitLabRunnerClaim` resources can be created only in the Claim Namespace created by `GitLabPipelinesIntegration`, which might be used to provide isolation between GitLab runners of different organization units. Administrator (owner of Puzl account) always has full permissions on all `GitLabRunnerClaim` resources within the Puzl account. The detailed description of the fields used in this module can be found in the related [GitLab Runner Claim documentation](https://gitlab-pipelines.puzl.cloud/docs/api/custom-puzl-resources/gitlab-runner-claim/).

## Features

- Management of GitLab Runner Claims.
- Outputs the name of Pipeline Namespace where the pipeline jobs are executed by the claimed runner.

## Requirements

- Terraform v1.3.0 or higher.
- Kubernetes provider v2.23.0 or higher.

## Usage

To use this module in your Terraform environment, add the following configuration:

```hcl
locals {
  gitlab_url           = "https://gitlab.com"
  integration_name     = "gitlab-group-integration"
  root_namespace       = "root-cysexkwsk57xtlabdkyn3zpybzslt2l7frtwj5arfodtz"
  token_name           = "gitlab-group-token"
  gitlab_access_token  = var.gitlab_access_token
  token_type           = "puzl.cloud/gitlab-group-access-token"
  claim_name           = "gitlab-runner"
}

module "integration" {
  source     = "puzl-cloud/gitlabpipelinesintegration/puzl"
  
  name       = local.integration_name
  namespace  = local.integration_namespace
  gitlab_url = local.gitlab_url
}

module "gitlab_access_token" {
  source               = "puzl-cloud/gitlabaccesstoken/puzl"

  name                 = local.name
  namespace            = module.integration.claim_namespace_ref
  gitlab_access_token  = local.gitlab_access_token
  token_type           = local.token_type
}

module "gitlab_runner_claim" {
  source = "puzl-cloud/gitlabrunnerclaim/puzl"
  
  name = local.claim_name
  namespace = module.integration.claim_namespace_ref
  gitlab_runner_claim = {
    gitlab = {
      groupId = 1
      runnerType = "group_type"
      tags = ["group-runner"]
    },
    pipelines = {
      delayOnStartForJobsWithServices = 0
    }
  }
}
```

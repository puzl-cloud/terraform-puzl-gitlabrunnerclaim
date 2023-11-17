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

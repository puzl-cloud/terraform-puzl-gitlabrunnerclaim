# Define Local Variables
locals {
  gitlab_url           = "https://gitlab.com"
  integration_name     = "main"
  root_namespace       = "root-cysexkwsk57xtlabdkyn3zpybzslt2l7frtwj5arfodtz"
  group_token_name     = "gitlab-group-token"
  project_token_name   = "gitlab-project-token"
  group_claim_name     = "gitlab-group-runner"
  project_claim_name   = "gitlab-project-runner"
}

# Create a GitLab Group
resource "gitlab_group" "example_group" {
  name        = "example-group"
  path        = "example-group"
  description = "An example group"
}

# Create a GitLab Project within the Group
resource "gitlab_project" "example_project" {
  name                   = "example-project"
  description            = "An example project"
  namespace_id           = gitlab_group.example_group.id
}

# Create a Group Access Token
resource "gitlab_group_access_token" "example_group_token" {
  group        = gitlab_group.example_group.id
  name         = "Group access token for create runner on https://gitlab-pipelines.puzl.cloud"
  expires_at   = "2024-12-31"
  access_level = "owner"
  scopes       = ["create_runner"]
}

# Create a Project Access Token
resource "gitlab_project_access_token" "example_project_token" {
  project      = gitlab_project.example_project.id
  name         = "Project access token for create runner on https://gitlab-pipelines.puzl.cloud"
  expires_at   = "2024-12-31"
  access_level = "maintainer"
  scopes       = ["create_runner"]
}

# Set up GitLab Pipelines Integration with Puzl modules
module "integration" {
  source     = "puzl-cloud/gitlabpipelinesintegration/puzl"

  name       = local.integration_name
  namespace  = local.root_namespace
  gitlab_url = local.gitlab_url
}

# Set up GitLab Group Access Token with Puzl modules
module "gitlab_group_access_token" {
  source               = "puzl-cloud/gitlabaccesstoken/puzl"

  name                 = gitlab_group_access_token.example_group_token.name
  namespace            = module.integration.claim_namespace_ref
  gitlab_access_token  = gitlab_group_access_token.example_group_token.token
  token_type           = "puzl.cloud/gitlab-group-access-token"
}

# Set up GitLab Project Access Token with Puzl modules
module "gitlab_project_access_token" {
  source               = "puzl-cloud/gitlabaccesstoken/puzl"

  name                 = gitlab_project_access_token.example_project_token.name
  namespace            = module.integration.claim_namespace_ref
  gitlab_access_token  = gitlab_project_access_token.example_project_token.token
  token_type           = "puzl.cloud/gitlab-project-access-token"
}

# Create GitLab Runner Claims for Group
module "gitlab_runner_claim_group" {
  source = "puzl-cloud/gitlabrunnerclaim/puzl"

  name = local.group_claim_name
  namespace = module.integration.claim_namespace_ref
  gitlab_runner_claim = {
    gitlab = {
      groupId = gitlab_group.example_group.id
      runnerType = "group_type"
      tags = ["group-runner"]
    },
    pipelines = {
      delayOnStartForJobsWithServices = 0
    }
  }
}

# Create GitLab Runner Claims for Project
module "gitlab_runner_claim_project" {
  source = "puzl-cloud/gitlabrunnerclaim/puzl"
  
  name = local.project_claim_name
  namespace = module.integration.claim_namespace_ref
  gitlab_runner_claim = {
    gitlab = {
      projectId = gitlab_project.example_project.id
      runnerType = "project_type"
      tags = ["project-runner"]
    },
    pipelines = {
      delayOnStartForJobsWithServices = 0
    }
  }
}

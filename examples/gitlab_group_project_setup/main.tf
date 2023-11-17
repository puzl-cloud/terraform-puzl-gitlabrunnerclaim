# Gitlab variables
locals {
  gitlab = {
    url = "https://gitlab.com"
    token = {
      expires_at = "2024-10-31"
      scopes = ["create_runner"]
    }
    groups = {
      main = {
        name = "main"
        description = "main group"
      },
      example = {
        name = "example-group"
        description = "example group"
      }
    },
    projects = {
      example = {
        name = "example-project"
        description = "example project"
      }
    }
  }
  puzl = {
    integration_name   = "main"
    root_namespace     = "root-cysexkwsk57xtlabdkyn3zpybzslt2l7frtwj5arfodtz"
  }
}
# Create a main GitLab Group
resource "gitlab_group" "main_group" {
  name        = local.gitlab.groups.main.name
  path        = local.gitlab.groups.main.name
  description = local.gitlab.groups.main.description
}

# Create a GitLab Group
resource "gitlab_group" "example_group" {
  name          = local.gitlab.groups.example.name
  path          = local.gitlab.groups.example.name
  description   = local.gitlab.groups.example.description
  parent_id     = gitlab_group.main_group.id
}

# Create a GitLab Project within the Group
resource "gitlab_project" "example_project" {
  name                   = local.gitlab.projects.example.name
  description            = local.gitlab.projects.example.description
  namespace_id           = gitlab_group.main_group.id
}

# Create a Group Access Token
resource "gitlab_group_access_token" "example_group_token" {
  group        = gitlab_group.example_group.id
  name         = "Group access token for create runner on https://gitlab-pipelines.puzl.cloud"
  expires_at   = local.gitlab.token.expires_at
  access_level = "owner"
  scopes       = local.gitlab.token.scopes
}

# Create a Project Access Token
resource "gitlab_project_access_token" "example_project_token" {
  project      = gitlab_project.example_project.id
  name         = "Project access token for create runner on https://gitlab-pipelines.puzl.cloud"
  expires_at   = local.gitlab.token.expires_at
  access_level = "maintainer"
  scopes       = local.gitlab.token.scopes
}

# Set up GitLab Pipelines Integration with Puzl modules
module "integration" {
  source     = "puzl-cloud/gitlabpipelinesintegration/puzl"

  name       = local.puzl.integration_name
  namespace  = local.puzl.root_namespace
  gitlab_url = local.gitlab.url
}

# Set up GitLab Group Access Token with Puzl modules
module "gitlab_group_access_token" {
  source               = "puzl-cloud/gitlabaccesstoken/puzl"

  name                 = "${gitlab_group.example_group.name}-token"
  namespace            = module.integration.claim_namespace_ref
  gitlab_access_token  = gitlab_group_access_token.example_group_token.token
  token_type           = "puzl.cloud/gitlab-group-access-token"
}

# Set up GitLab Project Access Token with Puzl modules
module "gitlab_project_access_token" {
  source               = "puzl-cloud/gitlabaccesstoken/puzl"

  name                 = "${gitlab_project.example_project.name}-token"
  namespace            = module.integration.claim_namespace_ref
  gitlab_access_token  = gitlab_project_access_token.example_project_token.token
  token_type           = "puzl.cloud/gitlab-project-access-token"
}

# Create GitLab Runner Claims for Group
module "gitlab_runner_claim_group" {
  source = "puzl-cloud/gitlabrunnerclaim/puzl"

  name = "${gitlab_group.example_group.name}-runner"
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
  
  name = "${gitlab_project.example_project.name}-runner"
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

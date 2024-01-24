variable "gitlab_runner_claim" {
  description = "Configuration for GitLab runner claim"
  type = object({
    gitlab = object({
      token          = optional(string)
      tags           = optional(list(string))
      runnerType     = optional(string)
      groupId        = optional(number)
      projectId      = optional(number)
      protected      = optional(bool, false)
      runUntaggedJobs = optional(bool, false)
    })
    pipelines = optional(object({
      ultimateJobTimeout              = optional(number)
      delayOnStartForJobsWithServices = optional(number)
      enableInteractiveWebTerminal    = optional(bool)
      resources                       = optional(object({
        dropContainerResourceLimits   = bool
      }))
      sharedMountPoints               = optional(list(string))
      sharedPersistentMountPoints     = optional(list(string))
    }))
  })

  validation {
    condition     = can(regex("^(project_type|group_type|instance_type)$", var.gitlab_runner_claim.gitlab.runnerType))
    error_message = "The gitlab.runnerType must be one of 'project_type', 'group_type', or 'instance_type'."
  }

  validation {
    condition     = var.gitlab_runner_claim.gitlab.groupId == null || var.gitlab_runner_claim.gitlab.runnerType == "group_type"
    error_message = "The gitlab.groupId can only be set if the gitlab.runnerType is 'group_type'."
  }

  validation {
    condition     = var.gitlab_runner_claim.gitlab.projectId == null || var.gitlab_runner_claim.gitlab.runnerType == "project_type"
    error_message = "The gitlab.projectId can only be set if the gitlab.runnerType is 'project_type'."
  }

  validation {
    condition     = var.gitlab_runner_claim.gitlab.runUntaggedJobs || length(var.gitlab_runner_claim.gitlab.tags) > 0
    error_message = "Tags must not be empty if runUntaggedJobs is false."
  }

  validation {
    condition     = !(var.gitlab_runner_claim.gitlab.groupId != null && var.gitlab_runner_claim.gitlab.projectId != null)
    error_message = "groupId and projectId cannot be set simultaneously."
  }

  validation {
    condition     = (var.gitlab_runner_claim.gitlab.token == "" || var.gitlab_runner_claim.gitlab.token == null) || (var.gitlab_runner_claim.gitlab.groupId == null && var.gitlab_runner_claim.gitlab.projectId == null)
    error_message = "If token is set, neither groupId nor projectId should be set."
  }
}

variable "name" {
  description = "The name for the GitLabRunnerClaim resource."
  type        = string
}

variable "namespace" {
  description = "Reference to the namespace for GitLabRunnerClaim resources"
  type        = string
}
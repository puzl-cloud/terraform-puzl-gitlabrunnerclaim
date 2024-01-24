resource "kubernetes_manifest" "gitlabrunnerclaim" {
  manifest = {
    apiVersion = "gitlab-pipelines.svcs.puzl.cloud/v1"
    kind       = "GitLabRunnerClaim"
    metadata = {
      name      = var.name
      namespace = var.namespace
    }
    spec = {
      gitlab = {
        token             = var.gitlab_runner_claim.gitlab.token
        tags              = var.gitlab_runner_claim.gitlab.tags
        runnerType        = var.gitlab_runner_claim.gitlab.runnerType
        groupId           = var.gitlab_runner_claim.gitlab.groupId
        projectId         = var.gitlab_runner_claim.gitlab.projectId
        protected         = var.gitlab_runner_claim.gitlab.protected
        runUntaggedJobs   = var.gitlab_runner_claim.gitlab.runUntaggedJobs
      }
      pipelines = {
        ultimateJobTimeout              = try(var.gitlab_runner_claim.pipelines.ultimateJobTimeout, null)
        delayOnStartForJobsWithServices = try(var.gitlab_runner_claim.pipelines.delayOnStartForJobsWithServices, 30)
        enableInteractiveWebTerminal    = try(var.gitlab_runner_claim.pipelines.enableInteractiveWebTerminal, false)
        resources = {
          dropContainerResourceLimits   = try(var.gitlab_runner_claim.pipelines.resources.dropContainerResourceLimits, true)
        }
        sharedMountPoints               = try(var.gitlab_runner_claim.pipelines.sharedMountPoints, ["/certs", "/var/run"])
        sharedPersistentMountPoints     = try(var.gitlab_runner_claim.pipelines.sharedMountPoints, [])
      }
    }
  }

  computed_fields = ["spec.gitlab", "spec.pipelines"]

  wait {
    fields = {
      "status.phase" = "Ready"
    }
  }

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}
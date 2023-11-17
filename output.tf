output "pipeline_namespace_ref" {
  value       = try(kubernetes_manifest.gitlabrunnerclaim.object.spec.runner.pipelineNamespaceRef, null)
  description = "The namespace where the pipeline jobs are executed by this runner."
}

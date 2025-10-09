output "gcp_service_account" {
  description = "Email of Wayfinder service account to use as spec.gcp.gcpServiceAccount of your cloud access"
  value       = google_service_account.wayfinder.email
}

output "gcp_projectnumber" {
  description = "Project Number of the GCP project to use as spec.gcp.projectNumber of your cloud access"
  value       = data.google_project.project.number
}

output "gcp_project" {
  description = "Project Name of the GCP project to use as spec.gcp.project of your cloud access"
  value       = data.google_project.project.name
}

output "gcp_workload_identity_pool_id" {
  description = "ID of GCP Workload Identity Pool to use as spec.gcp.workloadIdentityPoolID of your cloud access"
  value       = google_iam_workload_identity_pool.federated.workload_identity_pool_id 
}

output "gcp_workload_identity_provider_id" {
  description = "ID of GCP Workload Identity Provider to use as spec.gcp.workloadIdentityProviderID of your cloud access"
  value       = google_iam_workload_identity_pool_provider.federated.workload_identity_pool_provider_id
}

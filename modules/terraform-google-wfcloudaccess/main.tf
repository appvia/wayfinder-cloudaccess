locals {
  resource_prefix = "wf"
}

data "google_project" "project" {}

resource "google_project_service" "cloud_resource_manager_api" {
  disable_on_destroy = false
  project            = data.google_project.project.project_id
  service            = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "iam_credentials_api" {
  disable_on_destroy = false
  project            = data.google_project.project.project_id
  service            = "iamcredentials.googleapis.com"
}

resource "google_iam_workload_identity_pool" "federated" {
  workload_identity_pool_id = "${local.resource_prefix}pool${var.resource_suffix}"
  display_name              = "Wayfinder CloudIdentity trust"
  description               = "Provides access to GCP from Wayfinder"
  disabled                  = false
}

resource "google_iam_workload_identity_pool_provider" "federated" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.federated.workload_identity_pool_id
  workload_identity_pool_provider_id = "${local.resource_prefix}oidc${var.resource_suffix}"
  display_name                       = "Wayfinder OIDC Identity trust"
  description                        = "OIDC identity pool provider for Wayfinder OIDC"
  disabled                           = false
  attribute_condition                = "assertion.wf_target_account==\"${data.google_project.project.name}\""
  attribute_mapping = {
    # Use Wayfinder OIDC's subject claim to identify which Wayfinder cloud access this is presenting 
    # as (the subject is wayfinder:tenant:cloudaccessname)
    "google.subject" = "assertion.sub"
  }
  oidc {
    issuer_uri        = "https://${var.oidc_issuer}"
    allowed_audiences = [var.oidc_audience]
  }

  lifecycle {
    precondition {
      condition     = var.oidc_issuer != "" && var.oidc_audience != ""
      error_message = "Must specify oidc_issuer and oidc_audience to enable cross-cloud trust from Wayfinder OIDC to GCP"
    }
  }
}

resource "google_service_account" "wayfinder" {
  account_id   = "${var.service_account_name}${var.resource_suffix}"
  display_name = "Wayfinder"
}

resource "google_project_iam_member" "wayfinder" {
  project = data.google_project.project.id
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${google_service_account.wayfinder.email}"
}

resource "google_service_account_iam_member" "wayfinder" {
  service_account_id = google_service_account.wayfinder.name
  role               = "roles/iam.serviceAccountTokenCreator"
  # Allow access to the service account from the workload identity pool, matching the subject (mapped above from the Wayfinder OIDC 'sub' claim)
  member             = "principal://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.federated.workload_identity_pool_id}/subject/${var.oidc_subject}"
}

resource "google_project_iam_member" "role_assignments" {
  for_each = { for idx, role in var.role_assignments : idx => role }

  project = data.google_project.project.id
  role    = each.value
  member  = "serviceAccount:${google_service_account.wayfinder.email}"
}
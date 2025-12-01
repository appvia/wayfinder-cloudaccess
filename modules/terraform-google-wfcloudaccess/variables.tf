variable "project" {
  description = "GCP project to provide access to"
  type        = string
}

variable "service_account_name" {
  default     = "wayfinder"
  description = "Name of the service account to create for Wayfinder. resource_suffix will be appended to the name if set."
  type        = string
}

variable "resource_suffix" {
  default     = ""
  description = "Suffix to apply to all generated resources. We recommend using workspace key"
  type        = string
}

variable "wayfinder_tenant" {
  default     = ""
  description = "Tenant of Wayfinder to give access to. Populate when authenticating to GCP using Wayfinder's OIDC provider."
  type        = string
}

variable "oidc_issuer" {
  default     = ""
  description = "Issuer for Wayfinder's OIDC provider, without the https:// prefix"
  type        = string
}

variable "oidc_audience" {
  default     = ""
  description = "Audience for Wayfinder's OIDC provider. This is typically in the format wayfinder:TENANT"
  type        = string
}

variable "oidc_subject" {
  default     = ""
  description = "Subject of Wayfinder's OIDC provider to give access to. This is typically in the format wayfinder:TENANT:CLOUDACCESSNAME"
  type        = string
}

variable "role_assignments" {
  type        = list(string)
  description = "List of project roles to bind to the service account"
  default     = []
}

variable "enable_state_store" {
  type        = bool
  default     = false
  description = "Create a GCS bucket for Terraform state storage"
}

variable "state_store_bucket_name" {
  type        = string
  default     = ""
  description = "Name of the GCS bucket for state storage. Required if enable_state_store is true."
}

variable "state_store_location" {
  type        = string
  default     = "US"
  description = "Location for the GCS bucket (e.g., US, EU, us-central1)"
}

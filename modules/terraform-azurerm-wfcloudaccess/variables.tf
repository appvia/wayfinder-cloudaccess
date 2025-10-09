variable "subscription" {
  description = "Subscription ID to use for the federated identity"
  type        = string
}

variable "resource_suffix" {
  default     = ""
  description = "Suffix to apply to all generated resources. We recommend using workspace key"
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

variable "region" {
  default     = "uksouth"
  description = "Region for created resource group that holds the federated identity"
  type        = string
}

variable "role_assignments" {
  type = list(object({
    scope              = string
    role_definition_id = string
  }))
  description = "List of role assignments to create. Each object should contain a scope and role_definition_id."
  default     = []
}

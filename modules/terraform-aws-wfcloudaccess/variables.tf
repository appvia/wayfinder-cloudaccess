variable "account" {
  description = "AWS account to provide access to"
  type        = string
}

variable "iam_role_name" {
  default     = "wayfinder"
  description = "Name of the IAM role to create for Wayfinder. resource_suffix will be appended to the name if set."
  type        = string
}

variable "resource_suffix" {
  default     = ""
  description = "Suffix to apply to all generated resources. We recommend using workspace key"
  type        = string
}

variable "provision_oidc_trust" {
  default     = true
  description = "Provisions an AWS OIDC Provider reference for Wayfinder's OIDC provider. Set to false if the trust has already been provisioned in the account (it can only be provisioned once)."
  type        = bool
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

variable "policy_assignments" {
  type        = list(string)
  description = "List of ARNs of AWS policies to bind to the IAM role"
  default     = []
}

variable "role_permissions_boundary_arn" {
  default     = ""
  description = "ARN of the permissions boundary to apply to the IAM role"
  type        = string
}

variable "tags" {
  default     = {}
  description = "A map of tags to add to all resources created."
  type        = map(string)
}

variable "enable_state_store" {
  type        = bool
  default     = false
  description = "Create an S3 bucket for Terraform state storage"
}

variable "state_store_bucket_name" {
  type        = string
  default     = ""
  description = "Name of the S3 bucket for state storage. Required if enable_state_store is true."
}

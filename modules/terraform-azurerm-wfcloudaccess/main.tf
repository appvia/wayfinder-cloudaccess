locals {
  resource_prefix = "wf-"
  resource_suffix = var.resource_suffix != "" ? "-${var.resource_suffix}" : ""
}

data "azurerm_subscription" "primary" {
}

resource "azurerm_resource_group" "federated_identity" {
  name     = "${local.resource_prefix}federated-id${local.resource_suffix}"
  location = var.region
}
  
resource "azurerm_user_assigned_identity" "federated_identity" {
  location            = azurerm_resource_group.federated_identity.location
  name                = "${local.resource_prefix}federated-id${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.federated_identity.name
}

resource "azurerm_federated_identity_credential" "federated_identity_oidc" {
  name                = "${local.resource_prefix}federated-id-oidc${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.federated_identity.name
  parent_id           = azurerm_user_assigned_identity.federated_identity.id
  issuer              = var.oidc_issuer
  audience            = [var.oidc_audience]
  subject             = var.oidc_subject

  lifecycle {
    precondition {
      condition     = var.oidc_issuer != "" && var.oidc_audience != "" && var.oidc_subject != ""
      error_message = "Must specify issuer, audience, and subject to trust in oidc_issuer, oidc_audience, and oidc_subject"
    }
  }
}

resource "azurerm_role_assignment" "role_assignments" {
  for_each = { for idx, role in var.role_assignments : idx => role }

  scope              = each.value.scope
  role_definition_id = each.value.role_definition_id
  principal_id       = azurerm_user_assigned_identity.federated_identity.principal_id

  depends_on = [
    azurerm_user_assigned_identity.federated_identity
  ]
}
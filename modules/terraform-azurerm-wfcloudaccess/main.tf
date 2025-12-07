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
  issuer              = "https://${var.oidc_issuer}"
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

resource "azurerm_storage_account" "state_store" {
  count                    = var.enable_state_store ? 1 : 0
  name                     = var.state_store_storage_account_name
  resource_group_name      = azurerm_resource_group.federated_identity.name
  location                 = azurerm_resource_group.federated_identity.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  lifecycle {
    precondition {
      condition     = !var.enable_state_store || var.state_store_storage_account_name != ""
      error_message = "state_store_storage_account_name is required when enable_state_store is true"
    }
    precondition {
      condition     = !var.enable_state_store || var.state_store_container_name != ""
      error_message = "state_store_container_name is required when enable_state_store is true"
    }
  }
}

resource "azurerm_storage_container" "state_store" {
  count                 = var.enable_state_store ? 1 : 0
  name                  = var.state_store_container_name
  storage_account_id    = azurerm_storage_account.state_store[0].id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "state_store_access" {
  count              = var.enable_state_store ? 1 : 0
  scope              = azurerm_storage_account.state_store[0].id
  role_definition_id = "/subscriptions/${data.azurerm_subscription.primary.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe"
  principal_id       = azurerm_user_assigned_identity.federated_identity.principal_id

  depends_on = [
    azurerm_storage_account.state_store
  ]
}
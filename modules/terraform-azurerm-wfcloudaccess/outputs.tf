output "azure_subscription" {
  description = "Subscription ID of the Azure subscription to use as spec.azure.subscription of your cloud access"
  value       = data.azurerm_subscription.primary.subscription_id
}

output "azure_client_id" {
  description = "The client ID of the created managed identity to use as spec.azure.clientID in your cloud access"
  value       = azurerm_user_assigned_identity.federated_identity.client_id
}

output "azure_tenant_id" {
  description = "The tenant ID in which the managed identity exists, to use as spec.azure.tenantID in your cloud access"
  value       = data.azurerm_subscription.primary.tenant_id
}

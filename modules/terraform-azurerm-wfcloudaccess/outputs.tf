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

output "state_store_storage_account_name" {
  description = "Name of the storage account (for use in spec.stateStore.azureRM.storageAccountName)"
  value       = var.enable_state_store ? azurerm_storage_account.state_store[0].name : null
}

output "state_store_container_name" {
  description = "Name of the blob container (for use in spec.stateStore.azureRM.containerName)"
  value       = var.enable_state_store ? azurerm_storage_container.state_store[0].name : null
}

output "state_store_resource_group" {
  description = "Resource group containing the storage account (for use in spec.stateStore.azureRM.resourceGroup)"
  value       = var.enable_state_store ? azurerm_resource_group.federated_identity.name : null
}

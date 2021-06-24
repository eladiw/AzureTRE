output "workspace_name" {
    value = azurerm_machine_learning_workspace.ml.name
}

output "computeinstance_name" {
    value = local.aml_compute_instance_name
}

output "computecluster_name" {
    value = local.aml_compute_cluster_name
}

output "azureml_acr_name" {
    value = module.acr.name
}

output "azureml_storage_account_id" {
    value = module.storage.storage_account_id
}
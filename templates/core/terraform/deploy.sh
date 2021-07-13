cat >core_backend.tf <<TRE_BACKEND
terraform {
  backend "azurerm" {
    resource_group_name  = "$TF_VAR_mgmt_resource_group_name"
    storage_account_name = "$TF_VAR_mgmt_storage_account_name"
    container_name       = "$TF_VAR_terraform_state_container_name"
    key                  = "$TF_VAR_tre_id"
  }
}
TRE_BACKEND

export TF_VAR_docker_registry_server="$TF_VAR_acr_name.azurecr.io"
export TF_VAR_docker_registry_username=$TF_VAR_acr_name
export TF_VAR_docker_registry_password=$(az acr credential show --name ${TF_VAR_acr_name} --query passwords[0].value -o tsv | sed 's/"//g')

terraform init -input=false -backend=true -reconfigure -upgrade
terraform plan
terraform apply -auto-approve

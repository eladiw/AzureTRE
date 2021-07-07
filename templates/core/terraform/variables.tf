variable "tre_id" {
  type        = string
  description = "Unique identifier for the TRE, such as projectx-dev-1234"
  validation {
    condition     = length(var.tre_id) < 12
    error_message = "The tre_id value must be < 12 chars."
  }
}

variable "location" {
  type        = string
  description = "Azure region for deployment of core TRE services"
}

variable "address_space" {
  type        = string
  description = "Core services VNET Address Space"
}

variable "management_api_image_repository" {
  type        = string
  description = "Repository for management API image"
  default     = "microsoft/azuretre/management-api"
}

variable "management_api_image_tag" {
  type        = string
  description = "Tag for management API image"
  default     = "main-latest"
}

variable "processor_function_image_repository" {
  type        = string
  description = "Repository for processor function image"
  default     = "microsoft/azuretre/processor-function"
}

variable "processor_function_image_tag" {
  type        = string
  description = "Tag for processor function image"
  default     = "main-latest"
}

variable "mgmt_storage_account_name" {
  type        = string
  description = "Storage account created by bootstrap to hold all Terraform state"
}

variable "mgmt_resource_group_name" {
  type        = string
  description = "Shared management resource group"
}

variable "terraform_state_container_name" {
  type        = string
  description = "Name of the storage container for Terraform state"
}

variable "porter_output_container_name" {
  type        = string
  description = "Name of the storage container for Porter output"
}

variable "arm_client_id" {
  type        = string
  description = "The client (app) ID of a service principal with Owner role to the subscription."
}

variable "arm_client_secret" {
  type        = string
  description = "The client secret (app password) of a service principal with Owner role to the subscription."
}

variable "docker_registry_server" {
  type        = string
  description = "Docker registry server"
}

variable "docker_registry_username" {
  type        = string
  description = "Docker registry username"
}

variable "docker_registry_password" {
  type        = string
  description = "Docker registry password"
  sensitive   = true
}

variable "swagger_ui_client_id" {
  type        = string
  description = "The client id (app id) of the registration in Azure AD for the Swagger UI"
  sensitive   = true
}

variable "aad_tenant_id" {
  type        = string
  description = "The tenant id of the Azure AD used for authentication."
  sensitive   = true
}

variable "api_client_id" {
  type        = string
  description = "The client id (app id) of the registration in Azure AD for the API."
  sensitive   = true
}

variable "api_client_secret" {
  type        = string
  description = "A client secret use by the API to authenticate with Azure AD for access to Microsoft Graph."
  sensitive   = true
}

# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.58.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "core" {
  location = var.location
  name     = "rg-${var.tre_id}"
  tags = {
    project     = "Azure Trusted Research Environment"
    tre_id     = "${var.tre_id}"
    source      = "https://github.com/microsoft/AzureTRE/"
  }
}

resource "azurerm_log_analytics_workspace" "tre" {
  name                = "log-${var.tre_id}"
  resource_group_name = azurerm_resource_group.core.name
  location            = var.location
  retention_in_days   = 30
  sku                 = "pergb2018"
}

module "network" {
  source               = "./network"
  tre_id               = var.tre_id
  location             = var.location
  resource_group_name  = azurerm_resource_group.core.name
  address_space        = var.address_space
}

module "storage" {
  source               = "./storage"
  tre_id               = var.tre_id
  location             = var.location
  resource_group_name  = azurerm_resource_group.core.name
  shared_subnet        = module.network.shared
  core_vnet            = module.network.core
}

module "appgateway" {
  source               = "./appgateway"
  tre_id               = var.tre_id
  location             = var.location
  resource_group_name  = azurerm_resource_group.core.name
  app_gw_subnet        = module.network.app_gw
  management_api_fqdn  = module.api-webapp.management_api_fqdn
  keyvault_id          = module.keyvault.keyvault_id
  depends_on           = [module.keyvault]
}

module "api-webapp" {
  source                             = "./api-webapp"
  tre_id                             = var.tre_id
  location                           = var.location
  resource_group_name                = azurerm_resource_group.core.name
  web_app_subnet                     = module.network.web_app
  shared_subnet                      = module.network.shared
  app_gw_subnet                      = module.network.app_gw
  core_vnet                          = module.network.core
  log_analytics_workspace_id         = azurerm_log_analytics_workspace.tre.id
  management_api_image_repository    = var.management_api_image_repository
  management_api_image_tag           = var.management_api_image_tag
  docker_registry_server             = var.docker_registry_server
  docker_registry_username           = var.docker_registry_username
  docker_registry_password           = var.docker_registry_password
  state_store_endpoint               = module.state-store.endpoint
  state_store_key                    = module.state-store.primary_key
  service_bus_resource_request_queue = module.servicebus.workspacequeue
}

module "identity" {
  source               = "./user-assigned-identity"
  tre_id               = var.tre_id
  location             = var.location
  resource_group_name  = azurerm_resource_group.core.name
}

module "processor_function" {
  source                       = "./processor_function"
  tre_id                       = var.tre_id
  location                     = var.location
  resource_group_name          = azurerm_resource_group.core.name
  app_service_plan_id          = module.api-webapp.app_service_plan_id
  storage_account_name         = module.storage.storage_account_name
  storage_account_access_key   = module.storage.storage_account_access_key
  storage_state_path           = module.storage.storage_state_path
  identity_id                  = module.identity.identity_id
  core_vnet                    = module.network.core
  aci_subnet                   = module.network.aci
  docker_registry_username     = var.docker_registry_username
  docker_registry_password     = var.docker_registry_password
  docker_registry_server       = var.docker_registry_server
  servicebus_connection_string = module.servicebus.connection_string
  workspacequeue               = module.servicebus.workspacequeue
}

module "servicebus" {
  source               = "./servicebus"
  tre_id               = var.tre_id
  location             = var.location
  resource_group_name  = azurerm_resource_group.core.name
  shared_subnet        = module.network.shared
  core_vnet            = module.network.core
  tenant_id            = data.azurerm_client_config.current.tenant_id
}

module "keyvault" {
  source               = "./keyvault"
  tre_id               = var.tre_id
  location             = var.location
  resource_group_name  = azurerm_resource_group.core.name
  shared_subnet        = module.network.shared
  core_vnet            = module.network.core
  tenant_id            = data.azurerm_client_config.current.tenant_id
}

module "firewall" {
  source               = "./firewall"
  tre_id               = var.tre_id
  location             = var.location
  resource_group_name  = azurerm_resource_group.core.name
  firewall_subnet      = module.network.azure_firewall
  shared_subnet        = module.network.shared
}

module "routetable" {
  source                      = "./routetable"
  tre_id                      = var.tre_id
  location                    = var.location
  resource_group_name         = azurerm_resource_group.core.name
  shared_subnet               = module.network.shared
  firewall_private_ip_address = module.firewall.firewall_private_ip_address
}

module "acr" {
  source               = "./acr"
  tre_id               = var.tre_id
  location             = var.location
  resource_group_name  = azurerm_resource_group.core.name
  core_vnet            = module.network.core
  shared_subnet        = module.network.shared
}

module "state-store" {
  source               = "./state-store"
  tre_id               = var.tre_id
  location             = var.location
  resource_group_name  = azurerm_resource_group.core.name
  shared_subnet        = module.network.shared
  core_vnet            = module.network.core
}

module "bastion" {
  source               = "./bastion"
  tre_id               = var.tre_id
  location             = var.location
  resource_group_name  = azurerm_resource_group.core.name
  bastion_subnet        = module.network.bastion
}
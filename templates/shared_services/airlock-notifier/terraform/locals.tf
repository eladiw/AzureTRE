locals {
  core_resource_group_name = "rg-${var.tre_id}"
  airlock_notifier_app_name    =  "airlock-notifier-${var.tre_id}"
  storage_account_name     = lower(replace("stg-${var.tre_id}", "-", ""))
  tre_shared_service_tags = {
    tre_id                = var.tre_id
    tre_shared_service_id = var.tre_resource_id
  }
}
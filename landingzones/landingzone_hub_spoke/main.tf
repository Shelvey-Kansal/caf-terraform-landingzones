provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
  }
}

terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.19.0"
    }
  }
  required_version = ">= 0.13"
}

locals {
  landingzone_tag = {
    "landingzone" = basename(abspath(path.module))
  }
  tags = merge({ "environment" = local.environment }, var.tags, local.landingzone_tag)
}

data "terraform_remote_state" "landingzone_caf_foundations" {
  backend = "azurerm"
  config = {
    storage_account_name = var.lowerlevel_storage_account_name
    container_name       = var.workspace
    key                  = "landingzone_caf_foundations.tfstate"
    resource_group_name  = var.lowerlevel_resource_group_name
  }
}

locals {
  prefix                     = data.terraform_remote_state.landingzone_caf_foundations.outputs.prefix
  caf_foundations_accounting = data.terraform_remote_state.landingzone_caf_foundations.outputs.foundations_accounting
  caf_foundations_security   = data.terraform_remote_state.landingzone_caf_foundations.outputs.foundations_security
  global_settings            = data.terraform_remote_state.landingzone_caf_foundations.outputs.global_settings
  environment                = data.terraform_remote_state.landingzone_caf_foundations.outputs.environment
}
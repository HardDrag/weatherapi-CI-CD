terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = ">= 3.0.0"
    }
  }
}

terraform {
    backend "azurerm" {
      resource_group_name   = "tf_rg_blobstore"
      storage_account_name  = "tfstorageharddrag"
      container_name        = "tfstate"
      key                   = "terraform.tfstate" 
    }
}

variable "imagebuild" {
    type        = string
    description = "Latest Image Build"
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "tf_test" {
    name = "tfmainrg"
    location = "North Europe"
}

resource "azurerm_container_group" "tfcg_test" {
    name                        = "weatherapi"
    location                    = azurerm_resource_group.tf_test.location 
    resource_group_name         = azurerm_resource_group.tf_test.name

    ip_address_type = "Public"
    dns_name_label  = "harddrag"
    os_type         = "Linux"

    container {
        name            = "weatherapi"
        image           = "harddrag/weatherapi:${var.imagebuild}"
            cpu             = "1"
            memory          = "1"
 
            ports {
                port        = 80
                protocol    = "TCP"
            }
    }
}
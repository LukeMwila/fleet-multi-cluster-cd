provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

  backend "s3" {
    bucket = "euw1-fleet-multi-cluster-tf-state"
    key = "euw1-fleet-aks-multi-cluster/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}
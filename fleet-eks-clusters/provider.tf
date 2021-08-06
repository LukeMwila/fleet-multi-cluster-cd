provider "aws" {
  region = var.region
  profile = var.profile
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "euw1-fleet-multi-cluster-tf-state"
    key = "euw1-fleet-eks-multi-cluster/terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "euw1-fleet-eks-cluster-tf-state"
    encrypt = true
  }
}
provider "google" {
  project     = ""
  region      = "europe-west1"
  zone        = "europe-west1-a"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "euw1-fleet-multi-cluster-tf-state"
    key = "euw1-fleet-gke-multi-cluster/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}

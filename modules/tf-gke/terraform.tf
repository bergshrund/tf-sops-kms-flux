terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.10.0"
    }

    google-beta = {
      source = "hashicorp/google-beta"
      version = "5.10.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.24.0"
    }
  }
}
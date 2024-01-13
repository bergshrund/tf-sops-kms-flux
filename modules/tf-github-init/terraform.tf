terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.10.0"
    }

    github = {
      source = "integrations/github"
      version = "5.42.0"
    }
  }
}
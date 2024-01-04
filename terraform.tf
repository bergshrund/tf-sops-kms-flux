terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "5.42.0"
    }
  }

  backend "gcs" {
    bucket  = "data1-terraform-state"
    prefix  = "develop/kbot"
    impersonate_service_account = "devops@data1co.iam.gserviceaccount.com"
  }
}

data "local_file" "rd_file" {
  count = length(var.commit-files)
  filename = "./modules/tf-github-init/commit-files/${var.commit-files[count.index]}"
}

resource "google_service_account" "github_actions_service_account" {
  account_id   = var.github_actions_service_account_id
  display_name = "Github actions service account"
  project      = var.project_id
}

resource "google_project_iam_member" "github_actions_service_account" {
  count   = length(var.github_actions_service_account_iam_roles)
  project = var.project_id
  role    = element(var.github_actions_service_account_iam_roles, count.index)
  member  = "serviceAccount:${google_service_account.github_actions_service_account.email}"
}

module "gh_oidc" {
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  project_id  = var.project_id
  pool_id     = var.workload_identity_pool_id
  provider_id = var.workload_identity_provider_id
  sa_mapping = {
    "github-actions" = {
      sa_name   = google_service_account.github_actions_service_account.id
      attribute = "attribute.repository/${var.github_account}/${var.repository_name}"
    }
  }
}

locals {
  github_actions_secrets = {
    workload_identity_provider = module.gh_oidc.provider_name
    workload_identity_sa = google_service_account.github_actions_service_account.email
  }
}

resource "github_repository_file" "file" {
  count = length(var.commit-files) 
  repository          = var.repository_name
  branch              = "main"
  file                = "${var.target_path}/${var.commit-files[count.index]}"
  content             = data.local_file.rd_file[count.index].content
  commit_message      = "Added ${var.commit-files[count.index]}"
  commit_author       = "Terraform User"
  commit_email        = "terraform@gmail.com"
  overwrite_on_create = true
}

resource "github_actions_variable" "var" {
  for_each         = var.github_actions_vars
  repository       = var.repository_name
  variable_name    = each.key
  value            = each.value
}

resource "github_actions_secret" "secret" {
  for_each         = local.github_actions_secrets
  repository       = var.repository_name
  secret_name      = each.key
  plaintext_value  = each.value
}
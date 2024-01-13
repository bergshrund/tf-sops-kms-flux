data "local_file" "rd_file" {
  count = length(var.files)
  filename = "./modules/tf-github-init/commit-files/${var.files[count.index]}"
}

resource "github_repository_file" "file" {
  count = length(var.files) 
  repository          = var.repository_name
  branch              = "main"
  file                = "${var.target_path}/${var.files[count.index]}"
  content             = data.local_file.rd_file[count.index].content
  commit_message      = "Added ${var.files[count.index]}"
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
  for_each         = var.github_actions_secrets
  repository       = var.repository_name
  secret_name      = each.key
  plaintext_value  = each.value
}
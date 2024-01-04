resource "local_file" "kubeconfig" {
  content  = var.kubeconfig_content
  filename = var.kubeconfig_paths
}

provider "flux" {
  kubernetes = {
    config_path = local_file.kubeconfig.filename
    config_context = var.kubeconfig_context
  }

  git = {
    url = "ssh://git@github.com/${var.github_account}/${var.github_repository}.git"
    ssh = {
      username    = "git"
      private_key = var.private_key
    }
  }
}

module "flux_github_repository" {
  source                   = "../tf-github-repository"
  github_account           = var.github_account
  github_access_token      = var.github_access_token
  repository_name          = var.github_repository
  public_key_openssh       = var.public_key
  public_key_openssh_title = "flux"
}

resource "flux_bootstrap_git" "this" {
  depends_on = [module.flux_github_repository.github_repository_deploy_key]
  path = var.target_path
}

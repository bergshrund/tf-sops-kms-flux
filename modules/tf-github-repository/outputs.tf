output "github_repo" {
  value = github_repository.this.name
}

output "github_repository_deploy_key" {
  value = github_repository_deploy_key.this.id  
}
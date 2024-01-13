variable "repository_name" {
  type        = string
  description = "GitHub repository"
}

variable "target_path" {
  type        = string
  description = "Flux manifests subdirectory"
}

variable "files" {
  description = "Files that contains application resource definitions"
  type        = list(string)
}

variable "github_actions_vars" {
  description = "The list of githubActions variables"
  type        = map
}

variable "github_actions_secrets" {
  description = "The list of githubActions secrets"
  type        = map
}



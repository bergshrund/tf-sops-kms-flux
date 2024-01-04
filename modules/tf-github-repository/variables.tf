variable "github_account" {
  type        = string
  description = "The GitHub account that own repository"
}

variable "github_access_token" {
  type        = string
  description = "GitHub access token"
}

variable "repository_name" {
  type        = string
  description = "GitHub repository"
}

variable "repository_visibility" {
  type        = string
  default     = "private"
  description = "The visibility of the repository"
}

variable "public_key_openssh" {
  type        = string
  description = "OpenSSH public key repository access"
}

variable "public_key_openssh_title" {
  type        = string
  description = "The public key title"
}
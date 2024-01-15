variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "repository_name" {
  type        = string
  description = "GitHub repository"
}

variable "github_account" {
  type        = string
  description = "The GitHub account that own repository"
}

variable "target_path" {
  type        = string
  description = "Flux manifests subdirectory"
}

variable "commit-files" {
  description = "Files that contains application resource definitions"
  type        = list(string)
}

variable "github_actions_vars" {
  description = "The list of githubActions variables"
  type        = map
  default     = {
    secret_name = "kbot-token"
    secret_namespace = "kbot"
  }
}

variable "github_actions_service_account_iam_roles" {
  description = "List of IAM roles to assign to the github actions service account."
  type = list(string)
  default = [
    "roles/secretmanager.secretAccessor",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  ]
}

variable "github_actions_service_account_id" {
  type        = string
  default     = "github-actions"
  description = ""
}

variable "workload_identity_provider_id" {
  type        = string
  default     = "github-provider"
  description = "Workload Identity Pool Provider id"
}

variable "workload_identity_pool_id" {
  type        = string
  default     = "github-pool"
  description = "Workload Identity Pool ID"
}

variable "kms_crypto_key" {
  type        = string
  description = "The KMS crypto key full resource name is in the form projects/<project-is>/locations/<location>/keyRings/<key-ring-name>/cryptoKeys/<key-name>"
}

variable "gsm_secret" {
  type        = string
  description = "The Google Secret Manager secret full resource name in the form projects/<project-id>/secrets/<secret-name>"
}
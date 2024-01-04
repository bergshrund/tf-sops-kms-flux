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

variable "kbot_token" {
  description = "Kbot token"
  type        = string
}

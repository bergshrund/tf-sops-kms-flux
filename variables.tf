variable "github_account" {
  type        = string
  description = "The GitHub account that own repository"
}

variable "github_access_token" {
  type        = string
  description = "GitHub access token"
}

variable "github_repo" {
  type        = string
  description = "Flux configuration repo"
}

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
}

variable "zone" {
  type        = string
  description = "The zones to host the cluster in"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "vpc_network_name" {
  type        = string
  description = "The VPC network to host the cluster in"
}

variable "vpc_subnetwork_name" {
  type        = string
  description = "The subnetwork to host the cluster in"
}

variable "pods_subnetwork_range" {
  type        = string
  description = "The IP address range of the kubernetes pods in this cluster"
}

variable "svc_subnetwork_range" {
  type        = string
  description = "The IP address range of the kubernetes services in this cluster"
}

variable "node_pool_name" {
  type        = string
  description = "The name of the node pool"
}

variable "node_poll_machine_type" {
  type        = string
  description = "The name of a Google Compute Engine machine type"
}

variable "node_poll_size" {
  type        = number
  description = "The number of nodes in the nodepool"
}

variable "impersonate_service_account" {
  type        = string
  description = "The service account to impersonate for all Google API Calls"
}

variable "vpc_subnetwork_range" {
  type        = string
  description = "The IP address range of the kubernetes nodes in this cluster"
}

variable "kbot_token" {
  type        = string
  description = "Kbot token"
}

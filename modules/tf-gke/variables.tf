variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "impersonate_service_account" {
  description = "The service account to impersonate for all Google API Calls"
  type        = string
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
}

variable "zone" {
  description = "The zones to host the cluster in"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "vpc_network_name" {
  description = "The VPC network to host the cluster in"
  type        = string
}

variable "vpc_subnetwork_name" {
  description = "The subnetwork to host the cluster in"
  type        = string
}

variable "vpc_subnetwork_range" {
  description = "The IP address range of the kubernetes nodes in this cluster"
  type        = string
}

variable "pods_subnetwork_range" {
  description = "The IP address range of the kubernetes pods in this cluster"
  type        = string
}

variable "svc_subnetwork_range" {
  description = "The IP address range of the kubernetes services in this cluster"
  type        = string
}

variable "node_pool_name" {
  description = "The name of the node pool"
  type        = string
}

variable "node_poll_machine_type" {
  description = "The name of a Google Compute Engine machine type"
  type        = string
}

variable "node_poll_size" {
  description = "The number of nodes in the nodepool"
  type        = number
}

variable "cluster_service_account_iam_roles" {
  description = "List of IAM roles to assign to the default Kubernetes cluster service account."
  type = list(string)
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ]
}

variable "cluster_service_account_custom_iam_roles" {
  description = "List of arbitrary additional IAM roles to attach to the service account on the Kubernetes clusters nodes."
  type        = list(string)
  default     = []
}


output "kubeconfig_path" {
  value       = "${path.module}/kubeconfig"
  description = "The path to the kubeconfig file"
}

output "kubeconfig" {
  value       = module.gke_auth.kubeconfig_raw
  sensitive   = true
  description = "The full text of the kubeconfig that can be used to connect to this cluster"
}

output "context" {
  value       = module.gke.name
  description = "The name of the context in kubeconfig"
}
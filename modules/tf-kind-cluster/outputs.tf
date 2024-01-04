output "context" {
  value       = kind_cluster.this.context
  description = "The name of the context in KubeConfig"
}

output "kubeconfig" {
  value       = kind_cluster.this.kubeconfig
  sensitive   = true
  description = "The full text of the kubeconfig that can be used to connect to this cluster"
}

output "kubeconfig_path" {
  value       = "${path.module}/kind-config"
  description = "The path to the kubeconfig file"
}

resource "kind_cluster" "this" {
  name   = "test-cluster"
  config = <<-EOF
        apiVersion: kind.x-k8s.io/v1alpha4
        kind: Cluster
        nodes:
        - role: control-plane
        - role: worker
    EOF
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "echo '${kind_cluster.this.kubeconfig}' > ${path.module}/kind-config"
  }
}

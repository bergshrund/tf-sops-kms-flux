provider "github" {
  owner = var.github_account
  token = var.github_access_token
}

module "gke_cluster" {
  source = "./modules/tf-gke"
  project_id = var.project_id
  impersonate_service_account = var.impersonate_service_account
  region = var.region
  zone = var.zone
  cluster_name = var.cluster_name
  vpc_network_name = var.vpc_network_name
  vpc_subnetwork_name = var.vpc_subnetwork_name
  vpc_subnetwork_range = var.vpc_subnetwork_range
  pods_subnetwork_range = var.pods_subnetwork_range
  svc_subnetwork_range = var.svc_subnetwork_range
  node_pool_name = var.node_pool_name
  node_poll_machine_type = var.node_poll_machine_type
  node_poll_size = var.node_poll_size
}

#module "kind_cluster" {
#  source = "./modules/tf-kind-cluster"
#}

module "flux_bootstrap" {
  source              = "./modules/tf-flux-bootstrap"
  kubeconfig_content  = module.gke_cluster.kubeconfig
  kubeconfig_paths    = module.gke_cluster.kubeconfig_path
  kubeconfig_context  = module.gke_cluster.context
  github_account      = var.github_account
  github_repository   = var.github_repo
  github_access_token = var.github_access_token
  private_key         = module.tls_private_key.private_key_pem
  public_key          = module.tls_private_key.public_key_openssh
}

module "kbot" {
  depends_on = [ module.flux_bootstrap.flux_id ]
  source              = "./modules/tf-kbot"
  repository_name     = var.github_repo
  target_path         = module.flux_bootstrap.flux_path
  kbot_token          = var.kbot_token
  files = ["kbot/kbot-ns.yaml","kbot/kbot-secret.yaml","kbot/kbot-repo.yaml","kbot/kbot-helmrelease.yaml"]
}

module "tls_private_key" {
  source    = "./modules/tf-hashicorp-tls-key"
  algorithm = "RSA"
}

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

module "gke-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "kustomize-controller"
  namespace           = "flux-system"
  project_id          = var.project_id
  use_existing_k8s_sa = true
  cluster_name        = module.gke_cluster.context
  location            = module.gke_cluster.location
  annotate_k8s_sa     = false
  roles               = ["roles/cloudkms.cryptoKeyEncrypterDecrypter"]
}

module "flux_bootstrap" {
  source               = "./modules/tf-flux-bootstrap"
  kubeconfig_content   = module.gke_cluster.kubeconfig
  kubeconfig_paths     = module.gke_cluster.kubeconfig_path
  kubeconfig_context   = module.gke_cluster.context
  github_account       = var.github_account
  github_repository    = var.github_repo
  github_access_token  = var.github_access_token
  private_key          = module.tls_private_key.private_key_pem
  public_key           = module.tls_private_key.public_key_openssh
  workload_identity_sa = module.gke-workload-identity.gcp_service_account_email
}

module "kbot" {
  source              = "./modules/tf-github-init"
  depends_on          = [ module.flux_bootstrap.flux_id ]
  
  project_id          = var.project_id
  github_account      = var.github_account
  repository_name     = var.github_repo
  target_path         = "."

  kms_crypto_key      = var.kms_crypto_key
  gsm_secret          = var.gsm_secret

  commit-files = ["README.md",".github/workflows/update-token.yaml","${module.flux_bootstrap.flux_path}/kbot/kbot-ns.yaml","${module.flux_bootstrap.flux_path}/kbot/kbot-repo.yaml","${module.flux_bootstrap.flux_path}/kbot/kbot-helmrelease.yaml"]
}

module "tls_private_key" {
  source    = "./modules/tf-hashicorp-tls-key"
  algorithm = "RSA"
}
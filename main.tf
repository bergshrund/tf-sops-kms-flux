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

locals {
  kubeconfig      =  module.gke_cluster.kubeconfig
  kubeconfig_path =  module.gke_cluster.kubeconfig_path
  context         =  module.gke_cluster.context
}

module "flux_bootstrap" {
  source              = "./modules/tf-flux-bootstrap"
  kubeconfig_content  = local.kubeconfig
  kubeconfig_paths    = local.kubeconfig_path
  kubeconfig_context  = local.context
  github_account      = var.github_account
  github_repository   = var.github_repo
  github_access_token = var.github_access_token
  private_key         = module.tls_private_key.private_key_pem
  public_key          = module.tls_private_key.public_key_openssh
}

module "kbot" {
  depends_on = [ module.flux_bootstrap.flux_id ]
  source              = "./modules/tf-github-files"
  repository_name     = var.github_repo
  target_path         = module.flux_bootstrap.flux_path
  files = ["kbot/kbot-ns.yaml","kbot/kbot-token-enc.yaml","kbot/kbot-repo.yaml","kbot/kbot-helmrelease.yaml"]
}

module "github_actions" {
  depends_on = [ module.flux_bootstrap.flux_id ]
  source              = "./modules/tf-github-files"
  repository_name     = var.github_repo
  target_path         = "."
  files = [".github/workflows/update-token.yml"]
}

module "tls_private_key" {
  source    = "./modules/tf-hashicorp-tls-key"
  algorithm = "RSA"
}

module "gke-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  module_depends_on = [ module.flux_bootstrap ]
  name                = "kustomize-controller"
  namespace           = "flux-system"
  project_id          = var.project_id
  use_existing_k8s_sa = true
  cluster_name        = module.gke_cluster.context
  location            = module.gke_cluster.location
  annotate_k8s_sa     = true
  roles               = ["roles/cloudkms.cryptoKeyEncrypterDecrypter"]
}

module "gh_oidc" {
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  project_id  = var.project_id
  pool_id     = "github-pool"
  provider_id = "github-provider"
  sa_mapping = {
    "github-actions" = {
      sa_name   = "projects/data1co/serviceAccounts/github-actions@data1co.iam.gserviceaccount.com"
      attribute = "attribute.repository/bergshrund/flux"
    }
  }
}

#module "kms" {
#  source     = "./modules/tf-gcp-kms"
#  project_id = var.project_id
#  keyring    = "sops-flux"
#  location   = "global"
#  keys       = ["sops-key-flux"]
#}

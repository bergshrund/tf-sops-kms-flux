## Intro

For this demo, we assume a scenario involving a simple application running as a GKE cluster workload. The ultimate goal is to utilize Flux and Helm to manage application deployment in the cluster using the GitOps approach.

We will configure Flux to handle a simple app using GitRepository and HelmRelease custom resources. Flux will monitor the Git repository and automatically upgrade the Helm releases to their latest chart version.

## Prerequisites

We will employ Google Cloud service account impersonation as a generally safer way to run Terraform. This service account needs the necessary permissions to create the resources referenced in our code. Additionally, the Service Account Token Creator IAM role must be granted to our user account. This role enables us to impersonate service accounts to access APIs and resources. Following the principle of least privilege, the role should be granted to us in the service account’s IAM policy, not in the project’s IAM policy.

When we run Terraform code, it keeps track of the resources it manages in a state file. By default, the state file is generated in the Terraform working directory, but as a best practice, the state file should be stored in a more secure location. In our case, this is a GCS bucket that already exists but our user account doesn’t have access to. Instead, we will use a service account that does have access. This service account can be different from the one you’ll use to execute our Terraform code, but for simplicity, we will use the same one.

The `terraform.tf` file in our case will contain an example backend block that looks like this:

```hcl
backend "gcs" {
    bucket  = "data1-terraform-state"
    prefix  = "develop/kbot"
    impersonate_service_account = "devops@data1co.iam.gserviceaccount.com"
}
```

Additionally, we'll use a GitHub account and a personal access token that can create repositories.

## Bootstrapping Flux and Application

All input variable values will be placed in the `vars.tfvars` file, and Terraform will be run with the option `-var-file`:

```bash
terraform apply -var-file="vars.tfvars"
```

Here is an example of the content in `var.tfvars`:

```hcl
project_id = "test-project"
impersonate_service_account = "devops@test-project.iam.gserviceaccount.com"
region = "us-central1"
zone = "us-central1-a"
cluster_name = "test-cluster"
vpc_network_name = "test-vpc"
vpc_subnetwork_name = "test-vpc-subnet"
vpc_subnetwork_range = "192.168.1.0/24" 
pods_subnetwork_range = "10.10.0.0/16"
svc_subnetwork_range = "10.20.0.0/20"
node_pool_name = "default-pool"
node_pool_machine_type = "n2-standard-2"
node_pool_size = 2
github_account      = "myaccount"
github_access_token = "ggt_jhdfgiujkjsdhfgNOBR5M0pRhUGdL4Vaecx"
github_repo         = "flux"
kbot_token = "NjhgadfuighkjsdfgujkjUjhretjhkdDRNbnE5X0UtWQ=="
```

### Bootstrapping will include the following main steps:

1. Creating a new GKE cluster.
2. Bootstrapping Flux and creating a new GitHub repository where Flux keeps tracked artifacts and resource definitions.
3. Deploying the kbot application by adding new resource definitions to the Flux repo.

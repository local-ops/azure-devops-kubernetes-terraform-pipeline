terraform {
  backend "s3" {
    bucket = "mybucket"         # Kann separat verwaltet werden
    key    = "path/to/my/k8s/key"  # Eigener Key für den Kubernetes-State
    region = "eu-central-1"
  }
}

# Remote State, um die Outputs aus Stage 1 zu laden
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "eu-central-1"
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority)
  token                  = data.terraform_remote_state.eks.outputs.cluster_auth_token
}

resource "kubernetes_cluster_role_binding" "example" {
  metadata {
    name = "fabric8-rbac"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "default"
  }
}

resource "kubernetes_secret" "example" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = "default"
    }
    generate_name = "terraform-default-"
  }
  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}
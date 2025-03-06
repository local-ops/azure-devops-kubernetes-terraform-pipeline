# Terrafrom mit backend

terraform {
  backend "s3" {
    bucket = "mybucket"        # Wird in der Build-Pipeline überschrieben
    key    = "path/to/my/key"  # Wird in der Build-Pipeline überschrieben
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_default_vpc" "default" {
  # Standard VPC wird verwendet – in Prod empfiehlt sich ein eigenes VPC
}

module "in28minutes-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = "in28minutes-cluster2"
  cluster_version = "1.29"
  
  subnet_ids = [
    "subnet-098c6d8dfc5219693",
    "subnet-012819c48234aac76"
  ]
  vpc_id = aws_default_vpc.default.id

  # Damit der API-Server erreichbar ist
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name           = "node-group-1"
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
    two = {
      name           = "node-group-2"
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }
}

# Datenquelle, um den Cluster-Zustand abzurufen
data "aws_eks_cluster" "example" {
  name = module.in28minutes-cluster.cluster_name
}

data "aws_eks_cluster_auth" "example" {
  name = module.in28minutes-cluster.cluster_name
}

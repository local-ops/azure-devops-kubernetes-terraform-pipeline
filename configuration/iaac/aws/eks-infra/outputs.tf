output "cluster_endpoint" {
  value = data.aws_eks_cluster.example.endpoint
}

output "cluster_certificate_authority" {
  value = data.aws_eks_cluster.example.certificate_authority[0].data
}

output "cluster_name" {
  value = module.in28minutes-cluster.cluster_id
}

output "cluster_auth_token" {
  value = data.aws_eks_cluster_auth.example.token
  sensitive = true
}
# cluster endpoint
output "cluster_endpoint" {
 value = module.in28minutes-cluster.cluster_endpoint
}

# cluster certificate authority
output "cluster_certificate_authority" {
 value = module.in28minutes-cluster.cluster_certificate_authority
}   

# cluster name
output "cluster_name" {
 value = module.in28minutes-cluster.cluster_name
}   

# cluster auth_token
output "cluster_auth_token" {
 value = module.in28minutes-cluster.cluster_auth_token
}
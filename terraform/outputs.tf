
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnet_ids
}

output "private_subnets" {
  value = module.vpc.private_subnet_ids
}

output "jenkins_role_arn" {
  value = module.iam.jenkins_role_arn
}

output "jenkins_instance_profile_name" {
  value = module.iam.jenkins_instance_profile_name
}

output "eks_cluster_role_arn" {
  value = module.iam.eks_cluster_role_arn
}

output "eks_node_role_arn" {
  value = module.iam.eks_node_role_arn
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecr_repository_arn" {
  value = module.ecr.repository_arn
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_node_group_name" {
  value = module.eks.node_group_name
}

output "jenkins_instance_id" {
  value = module.jenkins.jenkins_instance_id
}

output "jenkins_public_ip" {
  value = module.jenkins.jenkins_public_ip
}

output "sonarqube_instance_id" {
  value = module.sonarqube.sonarqube_instance_id
}

output "sonarqube_public_ip" {
  value = module.sonarqube.sonarqube_public_ip
}
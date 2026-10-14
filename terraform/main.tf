
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source = "./modules/ecr"
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = "hotstar-eks"
  kubernetes_version = "1.35"

  private_subnet_ids = module.vpc.private_subnet_ids

  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn

  cluster_role_dependency = module.iam.eks_cluster_role_arn
  node_role_dependency    = module.iam.eks_node_role_arn
}

module "jenkins" {
  source = "./modules/jenkins"

  vpc_id = module.vpc.vpc_id

  public_subnet_id = module.vpc.public_subnet_ids[0]

  public_subnet_ids = module.vpc.public_subnet_ids

  ami_id = "ami-0969bf654d39c7a02"

  key_name = "hotstar-key"

  instance_profile_name = module.iam.jenkins_instance_profile_name

  ssh_allowed_cidr = "43.243.80.167/32"

  depends_on = [
    module.vpc,
    module.iam
  ]
}

module "sonarqube" {
  source = "./modules/sonarqube"

  vpc_id = module.vpc.vpc_id

  public_subnet_id = module.vpc.public_subnet_ids[1]

  ami_id = "ami-0c14b1acce9dc7578"

  key_name = "hotstar-key"

  ssh_allowed_cidr = "43.243.80.167/32"

  jenkins_security_group_id = module.jenkins.jenkins_security_group_id

  depends_on = [
    module.vpc
  ]
}
module "irsa" {
  source = "./modules/irsa"

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_issuer       = module.eks.oidc_issuer_url
  node_group_arn    = module.eks.node_group_arn

  depends_on = [
    module.eks
  ]
}

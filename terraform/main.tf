
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
  depends_on         = [module.iam]
  private_subnet_ids = module.vpc.private_subnet_ids

  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn
  jenkins_role_arn = module.iam.jenkins_role_arn
  #cluster_role_dependency = module.iam.eks_cluster_role_arn [2 nat]
  #node_role_dependency    = module.iam.eks_node_role_arn [2 nat]
}

module "jenkins" {
  create_alb = true
  source     = "./modules/jenkins"

  vpc_id = module.vpc.vpc_id

  public_subnet_id = module.vpc.public_subnet_ids[0]

  public_subnet_ids = module.vpc.public_subnet_ids

  ami_id = "ami-0d1649d90b05ccd6c"

  key_name = "hotstar-key"

  instance_profile_name = module.iam.jenkins_instance_profile_name

  ssh_allowed_cidr = "43.243.80.161/32"

  depends_on = [
    module.vpc,
    module.iam
  ]
}

module "sonarqube" {
  source = "./modules/sonarqube"

  vpc_id = module.vpc.vpc_id

  public_subnet_id = module.vpc.public_subnet_ids[1]

  ami_id = "ami-0cc53601d0a1c435c"

  key_name = "hotstar-key"

  ssh_allowed_cidr = "43.243.80.161/32"

  jenkins_security_group_id = module.jenkins.jenkins_security_group_id

  depends_on = [
    module.vpc
  ]
}
module "irsa" {
  source = "./modules/irsa"

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_issuer       = module.eks.oidc_issuer_url
  node_group_arns   = module.eks.node_group_arns

  depends_on = [
    module.eks
  ]
}

module "jenkins_agent" {
  source = "./modules/jenkins-agent"

  vpc_id                    = module.vpc.vpc_id
  private_subnet_id         = module.vpc.private_subnet_ids[0]
  ami_id                    = "ami-032eca770b5d15e72"
  key_name                  = "hotstar-key"
  instance_profile_name     = module.iam.jenkins_instance_profile_name
  jenkins_security_group_id = module.jenkins.jenkins_security_group_id

  instance_type = "t3.medium"
  volume_size   = 30

  depends_on = [
    module.vpc,
    module.iam
  ]
}

resource "aws_vpc_security_group_ingress_rule" "agent_to_sonarqube" {
  security_group_id            = module.sonarqube.sonarqube_security_group_id
  referenced_security_group_id = module.jenkins_agent.security_group_id

  from_port   = 9000
  to_port     = 9000
  ip_protocol = "tcp"

  description = "Allow Jenkins agent to access SonarQube"
}

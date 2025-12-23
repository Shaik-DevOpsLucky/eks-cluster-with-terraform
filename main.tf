module "vpc" {
  source       = "./modules/vpc"
  cluster_name = var.cluster_name
}

module "iam" {
  source = "./modules/iam"
}

module "bastion" {
  source            = "./modules/bastion"
  public_subnet_ids = module.vpc.public_subnet_ids
  instance_profile  = module.iam.bastion_instance_profile
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  private_subnet_ids = module.vpc.private_subnet_ids
  cluster_role_arn  = module.iam.eks_cluster_role_arn
  node_role_arn     = module.iam.eks_node_role_arn
}
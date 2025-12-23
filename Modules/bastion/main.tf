module "bastion" {
  source = "./modules/bastion"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  instance_profile  = module.iam.bastion_instance_profile

  ami_id        = "ami-0ecb62995f68bb549"
  instance_type = "t3.small"
}
# https://developer.hashicorp.com/terraform/language/modules/sources#local-paths

module "vpc" {
  source          = "../modules/vpc"
  region          = var.region
  vpc_cidr_block  = var.vpc_cidr_block
  environment     = var.environment
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "security_group" {
  source      = "../modules/sg"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}

module "ssh" {
  source       = "../modules/ssh"
  ssh_key_file = var.ssh_key_file
}

module "ec2" {
  source            = "../modules/ec2"
  environment       = var.environment
  api_sg_id         = module.security_group.api_sg_id
  public_subnets_id = module.vpc.public_subnets_id
  ssh_key_name      = module.ssh.ssh_key_name
  instance_type     = var.instance_type
  device_name       = var.device_name
  volume_size       = var.volume_size
  volume_type       = var.volume_type
}

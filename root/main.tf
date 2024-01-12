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

module "s3_bucket" {
  source      = "../modules/s3"
  environment = var.environment
}

module "iam" {
  source      = "../modules/iam"
  environment = var.environment
  s3_bucket   = module.s3_bucket.s3_bucket
}

module "rds" {
  source             = "../modules/rds"
  environment        = var.environment
  private_subnets_id = module.vpc.private_subnets_id
  db_sg_id           = module.security_group.db_sg_id
  database           = var.database
  dbuser             = var.dbuser
}

module "ssl_certificate" {
  source = "../modules/acm"
  domain = var.domain
}

module "load_balancer" {
  source            = "../modules/alb"
  environment       = var.environment
  alb_sg_id         = module.security_group.alb_sg_id
  public_subnets_id = module.vpc.public_subnets_id
  vpc_id            = module.vpc.vpc_id
  ssl_certificate   = module.ssl_certificate.ssl
}

module "route53" {
  source = "../modules/route53"
  domain = var.domain
  alb    = module.load_balancer.alb
}

module "ssh" {
  source       = "../modules/ssh"
  ssh_key_file = var.ssh_key_file
}

module "ec2" {
  source             = "../modules/ec2"
  environment        = var.environment
  api_sg_id          = module.security_group.api_sg_id
  public_subnets_id  = module.vpc.public_subnets_id
  ssh_key_name       = module.ssh.ssh_key_name
  instance_type      = var.instance_type
  device_name        = var.device_name
  volume_size        = var.volume_size
  volume_type        = var.volume_type
  database           = var.database
  dbuser             = var.dbuser
  db                 = module.rds.db
  iam_ec2_s3_profile = module.iam.iam_ec2_s3_profile
  owners             = var.owners
  ami_prefix         = var.ami_prefix
}

module "autoscaling_group" {
  source             = "../modules/asg"
  environment        = var.environment
  public_subnets_id  = module.vpc.public_subnets_id
  launch_template_id = module.ec2.launch_template_id
  alb_tg_arn         = module.load_balancer.alb_tg_arn
}

module "cloudwatch_metric_alarm" {
  source           = "../modules/cloudwatch"
  asg_name         = module.autoscaling_group.asg_name
  scale_out_policy = module.autoscaling_group.scale_out_policy
  scale_in_policy  = module.autoscaling_group.scale_in_policy
}

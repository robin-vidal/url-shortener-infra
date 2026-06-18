terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "url-shortener-tfstate-<ACCOUNT_ID>"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

module "vpc" {
  source        = "./modules/vpc"
  project       = var.project
  vpc_cidr      = "10.0.0.0/16"
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  azs           = ["us-east-1a", "us-east-1b"]
}

module "sg" {
  source  = "./modules/security-groups"
  project = var.project
  vpc_id  = module.vpc.vpc_id
}

module "rds" {
  source      = "./modules/rds"
  project     = var.project
  subnet_ids  = module.vpc.private_subnet_ids
  rds_sg_id   = module.sg.rds_sg_id
  db_name     = "urlshortener"
  db_user     = "urluser"
  db_password = var.db_password
}

module "ecr" {
  source  = "./modules/ecr"
  project = var.project
}

module "ec2" {
  source             = "./modules/ec2"
  project            = var.project
  ami_id             = var.ami_id
  key_name           = var.key_name
  public_subnet_ids  = module.vpc.public_subnet_ids
  bastion_sg_id      = module.sg.bastion_sg_id
  backend_sg_id      = module.sg.backend_sg_id
  frontend_sg_id     = module.sg.frontend_sg_id
}

module "alb" {
  source               = "./modules/alb"
  project              = var.project
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  alb_sg_id            = module.sg.alb_sg_id
  backend_instance_id  = module.ec2.backend_instance_id
  frontend_instance_id = module.ec2.frontend_instance_id
}

module "cloudwatch" {
  source               = "./modules/cloudwatch"
  project              = var.project
  alb_arn_suffix       = module.alb.alb_arn_suffix
  backend_instance_id  = module.ec2.backend_instance_id
  frontend_instance_id = module.ec2.frontend_instance_id
  db_identifier        = "${var.project}-db"
}

module "ssm" {
  source      = "./modules/ssm"
  project     = var.project
  db_host     = module.rds.db_endpoint
  db_name     = module.rds.db_name
  db_user     = module.rds.db_user
  db_password = var.db_password
}

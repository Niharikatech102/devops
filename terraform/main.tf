terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "DevOps-Platform"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  environment          = var.environment
}

module "security" {
  source = "./modules/security"
  
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  container_port = var.container_port
}

module "alb" {
  source = "./modules/alb"

  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  container_port    = var.container_port
}

module "ecs" {
  source = "./modules/ecs"

  environment            = var.environment
  aws_region             = var.aws_region
  private_subnet_ids     = module.vpc.private_subnet_ids
  ecs_tasks_sg_id        = module.security.ecs_tasks_sg_id
  target_group_arn       = module.alb.target_group_arn
  ecs_execution_role_arn = module.security.ecs_execution_role_arn
  ecs_task_role_arn      = module.security.ecs_task_role_arn
  container_port         = var.container_port
  container_image        = "nginx:latest" # Placeholder, will be overwritten by CI/CD
}

module "observability" {
  source = "./modules/observability"

  environment  = var.environment
  cluster_name = module.ecs.ecs_cluster_name
  service_name = module.ecs.ecs_service_name
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data sources
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Modules
module "networking" {
  source = "./modules/networking"
  vpc_id = data.aws_vpc.default.id
}

module "load_balancing" {
  source          = "./modules/load_balancing"
  vpc_id          = data.aws_vpc.default.id
  subnets         = data.aws_subnets.default.ids
  security_groups = [module.networking.alb_sg_id]
}

module "compute" {
  source            = "./modules/compute"
  ami_id            = data.aws_ami.amazon_linux_2023.id
  instance_type     = var.instance_type
  security_groups   = [module.networking.ec2_sg_id]
  subnets           = data.aws_subnets.default.ids
  target_group_arns = [module.load_balancing.target_group_arn]
  user_data         = file("user_data.sh")
}

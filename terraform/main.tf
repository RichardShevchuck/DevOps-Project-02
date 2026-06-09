terraform {
  required_version = ">= 0.12"
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

module "vpc_public" {
  source = "./modules/vpc_public"
}

module "vpc_private" {
  source = "./modules/vpc_private"
}


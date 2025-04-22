terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.95.0"
    }
  }
  backend "s3" {

    bucket = "my-state-managemnt-22-04-25"    
    key = "terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "dynamodb-state-table"

  }
}

provider "aws" {
  region = var.region
}


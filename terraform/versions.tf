terraform {
  backend "s3" {
    bucket = "my-bigg-state-bucc"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

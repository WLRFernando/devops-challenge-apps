terraform {
  required_version = "~> 1.3.2"
  required_providers {
    aws = {
      version = "~> 4.34.0"
    }
  }
}

provider "aws" {
  region  = var.region
}
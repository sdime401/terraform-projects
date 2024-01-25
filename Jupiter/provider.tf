terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "my-tf-state-bucket-ozzwm"
    key            = "my-tf-state-bucket-ozzwm/jupiterterraform.state"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
  }

}

provider "aws" {
  profile = "devopsprofile"
  region  = "us-east-1"
}

provider "aws" {
  profile = "devopsprofile"
  region  = "us-west-2"
  alias   = "west2"
}
# configure aws provider
provider "aws" {
  region = var.region
}

# configure backend
terraform {
  backend "s3" {
    bucket         = "test-lambda-events-bucket"
    key            = "aws-eks-terraform.tfstate"
    region         = "ap-south-1"
    # dynamodb_table = "terraform_state"
  }
}
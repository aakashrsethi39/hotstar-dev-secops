terraform {
  backend "s3" {
    bucket         = "hotstar-devsecops-terraform-state-2026"
    key            = "production/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "hotstar-devsecops-terraform-lock"
  }
}
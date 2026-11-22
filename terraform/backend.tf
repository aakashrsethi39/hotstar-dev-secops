terraform {
  backend "s3" {
    bucket         = "hotstar-devsecops-tfstate-630702276489"
    key            = "production/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "hotstar-devsecops-terraform-lock-new"
  }
}

terraform {
  backend "s3" {
    bucket = "hypha-terraform-backend-01"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

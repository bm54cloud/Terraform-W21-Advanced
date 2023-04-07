#Declare S3 backend
#https://developer.hashicorp.com/terraform/language/settings/backends/s3
terraform {
  backend "s3" {
    bucket = "terraform-backend-w21-adv"
    key    = "State-Files/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "Terraform-S3-backend"
    encrypt        = true
  }
}


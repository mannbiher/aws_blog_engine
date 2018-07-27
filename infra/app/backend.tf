terraform {
  backend "s3" {
    bucket  = "m-terraform-state"
    key     = "aws_blog_engine/app/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

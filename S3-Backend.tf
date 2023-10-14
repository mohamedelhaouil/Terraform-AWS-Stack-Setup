terraform {
  backend "s3" {
    bucket = "terraform-mel05-projects-state"
    key    = "AWS-Stack-Setup(VPC & Web Infra Stack)/terraform.tfstate"
    region = "us-east-1"
  }
}
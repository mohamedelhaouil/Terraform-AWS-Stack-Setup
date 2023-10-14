module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = var.VpcNAME
  cidr                 = var.VpcCIDR
  azs                  = var.Zones
  private_subnets      = var.PrivSubnetCIDR
  public_subnets       = var.PubSubnetCIDR
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Terraform = "true"
    Env       = "Dev"
  }
  vpc_tags = {
    Name = var.VpcNAME
  }
}
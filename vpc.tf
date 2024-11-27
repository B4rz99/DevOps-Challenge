module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Acklen Avenue VPC"
  cidr = var.vpc_cidr

  azs             = [var.azs[0], var.azs[1]]
  public_subnets  = [var.public_subnets[0], var.public_subnets[1]]
  public_subnet_names = ["Acklen-Avenue-Subnet-1", "Acklen-Avenue-Subnet-2"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Environment = "intern"
  }
}
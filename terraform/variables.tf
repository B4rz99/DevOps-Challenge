variable "vpc_cidr" {
    description = "The CIDR block for the VPC in AZ 1"
}

variable "azs" {
    description = "The availability zones for the VPC"
    type = list(string)
  
}

variable "public_subnets" {
    description = "The CIDR blocks for the public subnets"
    type = list(string)
  
}
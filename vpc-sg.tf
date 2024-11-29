resource "aws_security_group" "AcklenAvenueVPCSecurityGroup" {
  name        = "AcklenAvenueVPCSecurityGroup"
  description = "VPC Security Group"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.AcklenAvenueVPCSecurityGroup.id
  cidr_ipv4   = var.vpc_cidr
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  description = "Allow HTTP traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.AcklenAvenueVPCSecurityGroup.id
  cidr_ipv4   = var.vpc_cidr
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  description = "Allow HTTPS traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.AcklenAvenueVPCSecurityGroup.id
  cidr_ipv4   = var.vpc_cidr
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  description = "Allow SSH traffic"
  
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.AcklenAvenueVPCSecurityGroup.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}
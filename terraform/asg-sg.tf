resource "aws_security_group" "AcklenAvenueASGSecurityGroup" {
    name        = "AcklenAvenueASGSecurityGroup"
    description = "Allow inbound HTTP, HTTPS, and SSH traffic and all outbound traffic"
    vpc_id      = module.vpc.vpc_id
    depends_on = [module.vpc]
}

resource "aws_security_group_rule" "allow_http" {
    type              = "ingress"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = [module.vpc.vpc_cidr_block]
    security_group_id = aws_security_group.AcklenAvenueASGSecurityGroup.id
    description       = "Allow HTTP traffic"
}

resource "aws_security_group_rule" "allow_ssh" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = [var.my-ip]
    security_group_id = aws_security_group.AcklenAvenueASGSecurityGroup.id
    description       = "Allow SSH traffic"
  
}

resource "aws_security_group_rule" "allow_all_traffic_ipv4" {
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.AcklenAvenueASGSecurityGroup.id
    description       = "Allow all outbound traffic (IPv4)"
}

resource "aws_security_group_rule" "allow_all_traffic_ipv6" {
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1" 
    ipv6_cidr_blocks  = ["::/0"]
    security_group_id = aws_security_group.AcklenAvenueASGSecurityGroup.id
    description       = "Allow all outbound traffic (IPv6)"
}
output "public_subnet_ids" {
    value = module.vpc.public_subnets
}

output "vpc_id" {
    value = module.vpc.vpc_id
}

output "target_group_arns" {
  value = aws_lb_target_group.instance_target_group.arn
}

output "private_key_pem" {
  value = module.key_pair.private_key_pem
  sensitive = true
}
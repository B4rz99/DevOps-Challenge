module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  name = "Acklen-Avenue-ASG"

  min_size                  = 2
  max_size                  = 2
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.public_subnets

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
      max_healthy_percentage = 100
    }
  }

  # Launch template
  launch_template_name        = "Acklen-Avenue-Launch-Template"
  launch_template_description = "Launch template for EC2 instances"
  update_default_version      = true

  image_id          = "ami-0866a3c8686eaeeba"
  instance_type     = "t3.micro"

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "Acklen-Avenue-Role"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role for EC2 instances"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
    }
  ]

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  network_interfaces = [
    {
      delete_on_termination = true
      device_index          = 0
      security_groups       = [aws_security_group.AcklenAvenueASGSecurityGroup.id]
    }
  ]

  placement = {
    availability_zone = var.azs[0]
  }

  tags = {
    Environment = "intern"
  }
}
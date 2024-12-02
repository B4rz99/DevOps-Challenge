# Define the AWS Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  name                      = "Acklen-Avenue-ASG"
  max_size                  = 2
  min_size                  = 2
  desired_capacity          = 2
  vpc_zone_identifier       = module.vpc.public_subnets
  health_check_type         = "EC2"
  health_check_grace_period = 300
  target_group_arns = [aws_lb_target_group.instance_target_group.arn]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Environment"
    value               = "Intern"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "Acklen-Avenue-Instance"
    propagate_at_launch = true
  }
}

# Define the AWS Launch Template for EC2 Instances
resource "aws_launch_template" "lt" {
  name          = "Acklen-Avenue-Launch-Template"
  description   = "Launch template for EC2 instances"
  image_id      = "ami-0866a3c8686eaeeba"
  instance_type = "t3.micro"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_size           = 20
      volume_type           = "gp2"
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    device_index                = 0
    security_groups             = [aws_security_group.AcklenAvenueASGSecurityGroup.id]
  }
}

# Define the IAM Role and Instance Profile for EC2
resource "aws_iam_role" "ec2_role" {
  name               = "Acklen-Avenue-Role"
  path               = "/ec2/"
  description        = "IAM role for EC2 instances"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "Acklen-Avenue-Instance-Profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
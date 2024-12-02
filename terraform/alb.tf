# Security Group for the ALB
resource "aws_security_group" "alb_sg" {
  name        = "Acklen-Avenue-ALB-SG"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic from the world"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

# Load Balancer (ALB)
resource "aws_lb" "alb" {
  name               = "Acklen-Avenue-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.s3-logs.bucket
    enabled = true
    prefix  = "obarbozaa"
  }

  tags = {
    Environment = "Intern"
    Project     = "Acklen Avenue"
  }
}

# Target Group
resource "aws_lb_target_group" "instance_target_group" {
  name_prefix   = "h1"
  protocol      = "HTTP"
  port          = 80
  target_type   = "instance"
  vpc_id        = module.vpc.vpc_id

  health_check {
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Environment = "Intern"
    Project     = "Acklen Avenue"
  }
}

# Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance_target_group.arn
  }
}
resource "aws_security_group" "jenkins" {
  name        = "hotstar-jenkins-sg"
  description = "Security group for Jenkins EC2"
  vpc_id      = var.vpc_id

  tags = {
    Name = "hotstar-jenkins-sg"
  }
}

# SSH access to Jenkins
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.jenkins.id

  cidr_ipv4   = var.ssh_allowed_cidr
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "SSH"

  lifecycle {
    ignore_changes = [
      cidr_ipv4
    ]
  }
}

# Allow ALB to reach Jenkins
resource "aws_vpc_security_group_ingress_rule" "jenkins_from_alb" {
  count                        = var.create_alb ? 1 : 0
  security_group_id            = aws_security_group.jenkins.id
  referenced_security_group_id = aws_security_group.jenkins_alb[0].id

  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"

  description = "Jenkins access from ALB"
}

# Jenkins outbound internet access
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.jenkins.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow all outbound traffic"
}


resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = "t3.small"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.jenkins.id]
  iam_instance_profile        = var.instance_profile_name
  key_name                    = var.key_name
  associate_public_ip_address = false


  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "hotstar-jenkins"
  }

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      associate_public_ip_address
    ]
  }
}


# Security group for Jenkins ALB
resource "aws_security_group" "jenkins_alb" {
  count       = var.create_alb ? 1 : 0
  name        = "hotstar-jenkins-alb-sg"
  description = "Security group for Jenkins ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "GitHub webhook HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = [
      "9.234.106.48/28",
      "9.234.98.160/28",
      "9.234.98.176/28",
      "192.30.252.0/22",
      "185.199.108.0/22",
      "140.82.112.0/20",
      "143.55.64.0/20"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hotstar-jenkins-alb-sg"
  }
}


# Jenkins Application Load Balancer
resource "aws_lb" "jenkins" {
  count              = var.create_alb ? 1 : 0
  name               = "hotstar-jenkins-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.jenkins_alb[0].id
  ]

  subnets = var.public_subnet_ids

  tags = {
    Name = "hotstar-jenkins-alb"
  }
}


# Jenkins target group
resource "aws_lb_target_group" "jenkins" {
  count       = var.create_alb ? 1 : 0
  name        = "hotstar-jenkins-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/login"
    protocol            = "HTTP"
    port                = "8080"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "hotstar-jenkins-tg"
  }
}


# Register Jenkins EC2 with target group
resource "aws_lb_target_group_attachment" "jenkins" {
  count            = var.create_alb ? 1 : 0
  target_group_arn = aws_lb_target_group.jenkins[0].arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}


# Jenkins ALB listener
resource "aws_lb_listener" "jenkins" {
  count             = var.create_alb ? 1 : 0
  load_balancer_arn = aws_lb.jenkins[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Access Denied"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "github_webhook" {
  count        = var.create_alb ? 1 : 0
  listener_arn = aws_lb_listener.jenkins[0].arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins[0].arn
  }

  condition {
    path_pattern {
      values = ["/github-webhook/"]
    }
  }

  condition {
    http_request_method {
      values = ["POST"]
    }
  }
}

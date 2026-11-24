resource "aws_security_group" "agent" {
  name        = "hotstar-jenkins-agent-sg"
  description = "Security group for Jenkins build agent"
  vpc_id      = var.vpc_id

  tags = {
    Name = "hotstar-jenkins-agent-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id            = aws_security_group.agent.id
  referenced_security_group_id = var.jenkins_security_group_id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "SSH from Jenkins controller"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.agent.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "agent" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.agent.id]
  iam_instance_profile        = var.instance_profile_name
  key_name                    = var.key_name
  associate_public_ip_address = false

  user_data = file("${path.module}/user-data.sh")

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "hotstar-jenkins-agent"
    Role = "jenkins-agent"
  }
}

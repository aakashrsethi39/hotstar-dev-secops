resource "aws_security_group" "sonarqube" {
  name        = "hotstar-sonarqube-sg"
  description = "Security group for SonarQube"
  vpc_id      = var.vpc_id

  tags = {
    Name = "hotstar-sonarqube-sg"
  }
}


# SSH access to SonarQube
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.sonarqube.id

  cidr_ipv4   = var.ssh_allowed_cidr
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "SSH"
}


# Jenkins -> SonarQube
resource "aws_vpc_security_group_ingress_rule" "jenkins_to_sonarqube" {
  security_group_id            = aws_security_group.sonarqube.id
  referenced_security_group_id = var.jenkins_security_group_id

  from_port   = 9000
  to_port     = 9000
  ip_protocol = "tcp"

  description = "Allow Jenkins to access SonarQube"
}


# SonarQube outbound access
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.sonarqube.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow all outbound traffic"
}


resource "aws_instance" "sonarqube" {
  ami                         = var.ami_id
  instance_type               = "c7i-flex.large"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.sonarqube.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = file("${path.module}/user-data.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "hotstar-sonarqube"
  }
}


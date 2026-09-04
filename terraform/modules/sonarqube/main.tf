resource "aws_security_group" "sonarqube" {
  name        = "hotstar-sonarqube-sg"
  description = "Security group for SonarQube"
  vpc_id      = var.vpc_id

  # SonarQube
  ingress {
    description = "SonarQube"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hotstar-sonarqube-sg"
  }
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
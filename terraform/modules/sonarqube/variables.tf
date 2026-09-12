variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "ssh_allowed_cidr" {
  type = string
}

variable "jenkins_security_group_id" {
  description = "Security group ID of Jenkins"
  type        = string
}
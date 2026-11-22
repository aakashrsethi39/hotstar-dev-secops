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

variable "instance_profile_name" {
  type = string
}

variable "ssh_allowed_cidr" {
  type = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for Jenkins ALB"
  type        = list(string)
}

variable "create_alb" {
  description = "Whether to create the Jenkins Application Load Balancer"
  type        = bool
  default     = false
}

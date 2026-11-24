variable "vpc_id" {
  type = string
}

variable "private_subnet_id" {
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

variable "jenkins_security_group_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "volume_size" {
  type    = number
  default = 30
}

variable "cluster_name" {
  type    = string
  default = "hotstar-eks"
}

variable "kubernetes_version" {
  type    = string
  default = "1.35"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}

#variable "cluster_role_dependency" { [2 nat]
#type = any
#}

#variable "node_role_dependency" {   [2 nat]
#type = any
#}


variable "jenkins_role_arn" {
  description = "IAM role ARN used by Jenkins to deploy applications"
  type        = string
}

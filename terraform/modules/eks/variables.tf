variable "cluster_name" {
  type    = string
  default = "hotstar-eks"
}

variable "kubernetes_version" {
  type    = string
  default = "1.33"
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

variable "cluster_role_dependency" {
  type = any
}

variable "node_role_dependency" {
  type = any
}
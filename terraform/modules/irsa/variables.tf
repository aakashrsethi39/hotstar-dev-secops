variable "oidc_provider_arn" {
  type = string
}

variable "oidc_issuer" {
  type = string
}

variable "node_group_arns" {
  description = "ARNs of EKS managed node groups"
  type        = list(string)
}

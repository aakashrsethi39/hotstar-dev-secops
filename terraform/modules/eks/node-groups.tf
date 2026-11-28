resource "aws_eks_node_group" "ondemand" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-ondemand"
  node_role_arn   = var.node_role_arn

  subnet_ids = [
    "subnet-0afd5cdaf01b98130"
  ]

  instance_types = ["m7i-flex.large"]
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }
}


resource "aws_eks_node_group" "spot" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-spot"
  node_role_arn   = var.node_role_arn

  subnet_ids = var.private_subnet_ids

  instance_types = ["c7i-flex.large"]
  capacity_type  = "SPOT"

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 4
  }

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }
}

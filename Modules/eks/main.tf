resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }
}

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "private-ng"
  node_role_arn  = var.node_role_arn
  subnet_ids     = var.private_subnet_ids

  scaling_config {
    desired_size = 3
    min_size     = 2
    max_size     = 5
  }

  disk_size      = 20
  instance_types = ["t3.small"]
  ami_type       = "AL2_x86_64"
}
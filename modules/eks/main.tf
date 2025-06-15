# Creating EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.master_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = [
      var.public_subnet_az1_id,
      var.public_subnet_az2_id
    ]
  }

  tags = {
    key   = var.env
    value = var.type
  }
}

# Using Data Source to get all Availability Zones in Region
data "aws_availability_zones" "available_zones" {}

# Creating Launch Template for Worker Nodes
resource "aws_launch_template" "worker-node-launch-template" {
  name = "worker-node-launch-template"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  image_id      = var.image_id
  instance_type = var.instance_size

  user_data = base64encode(<<-EOF
    #!/bin/bash
    /etc/eks/bootstrap.sh ${var.cluster_name}
  EOF
  )

  vpc_security_group_ids = [
    var.eks_security_group_id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Worker-Nodes"
    }
  }
}

# Creating Worker Node Group
resource "aws_eks_node_group" "node-grp" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "Worker-Node-Group"
  node_role_arn   = var.worker_arn
  subnet_ids = [
    var.public_subnet_az1_id,
    var.public_subnet_az2_id
  ]

  launch_template {
    name    = aws_launch_template.worker-node-launch-template.name
    version = aws_launch_template.worker-node-launch-template.latest_version
  }

  labels = {
    env = "Prod"
  }

  scaling_config {
    desired_size = var.worker_node_count
    max_size     = 7
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}

# Defining local variable for EKS Addons
locals {
  eks_addons = {
    "vpc-cni" = {
      version           = var.vpc-cni-version
      resolve_conflicts = "OVERWRITE"
    },
    "kube-proxy" = {
      version           = var.kube-proxy-version
      resolve_conflicts = "OVERWRITE"
    }
  }
}

# Creating the EKS Addons
resource "aws_eks_addon" "example" {
  for_each = local.eks_addons

  cluster_name                = aws_eks_cluster.eks.name
  addon_name                  = each.key
  addon_version               = each.value.version
  resolve_conflicts_on_update = each.value.resolve_conflicts
}


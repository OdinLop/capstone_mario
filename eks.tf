resource "aws_iam_role" "NodeGroupRole" {
 name = "EKSNodeGroupRole"
 assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
 })
}

resource "aws_iam_role_policy_attachment" "NodeGroupRole_AmazonEKSWorkerNodePolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
 role       = aws_iam_role.NodeGroupRole.name
}

resource "aws_eks_node_group" "example" {
 cluster_name    = aws_eks_cluster.main.name
 node_group_name = "example"
 node_role_arn   = aws_iam_role.NodeGroupRole.arn
 subnet_ids      = [aws_subnet.main.id]
 scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
 }

 instance_types = ["t3.micro"]

 depends_on = [
    aws_iam_role_policy_attachment.NodeGroupRole_AmazonEKSWorkerNodePolicy,
 ]
}

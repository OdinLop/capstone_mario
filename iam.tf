resource "aws_iam_role" "eks_worker_nodes" {
 name = "eks-worker-nodes"

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

resource "aws_iam_role_policy_attachment" "eks_worker_nodes" {
 role       = aws_iam_role.eks_worker_nodes.name
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

#ROLE
resource "aws_iam_role" "eks-role" {
  name               = "eks-cluster"
  assume_role_policy = data.aws_iam_policy_document.assume_role_eks.json
}

resource "aws_iam_role_policy_attachment" "EKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-role.name
}



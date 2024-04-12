# Code for Deploying the EKS Cluster
resource "aws_eks_cluster" "app_cluster" {      
  name     = var.cluster_name
  role_arn = aws_iam_role.eks-role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.PublicSubn1.id,
      aws_subnet.PublicSubn2.id,
      aws_subnet.PrivateSubn1A.id,
      aws_subnet.PrivateSubn2B.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.EKSClusterPolicy,
   
  ]
}
#Policies assignment

resource "aws_iam_role" "node-role" {
  name = "node-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-role.name
}

#Code for deploying the node Group to EKS cluster
resource "aws_eks_node_group" "node-group" {
  cluster_name    = aws_eks_cluster.app_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.node-role.arn
  subnet_ids      = [
    aws_subnet.PrivateSubn1A.id, 
    aws_subnet.PrivateSubn2B.id]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  instance_types = [ "t2.micro" ]
  capacity_type = "ON_DEMAND"
  disk_size = 20
  

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

#Outputs
output "endpoint" {
  value = "${aws_eks_cluster.app_cluster.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.app_cluster.certificate_authority[0].data}"
}
#VPC

variable "VPC_Name" {
    description = "VPC name"
    default = "vpc_1"
}
variable "cidr" {
    description = "CIDR"
    default = "10.0.0.0/16"
}

#Subnets
variable "AZ_1A" {
    default = "us-east-1a"
  
}
variable "AZ_1B" {
    default = "us-east-1b"
  
}
variable "BIDEN_IP" {
  description = "ALLOWS EVERYONE"
  default = "0.0.0.0/0"
}

variable "node_group_name" {
  default = "NodeGroup1"
}

variable "cluster_name" {
  default = "app_cluster"
}

#Policies
data "aws_iam_policy_document" "assume_role_eks" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}
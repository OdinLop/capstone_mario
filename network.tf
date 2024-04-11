#VPC
resource "aws_vpc" "main_vpc" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"       

  tags = {
    Name = var.VPC_Name
  }
}

#Subnets
resource "aws_subnet" "PublicSubn1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone =var.AZ_1A

  tags = {
    Name = "Main-Public-Subnet1"
  }
}

resource "aws_subnet" "PublicSubn2" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone =var.AZ_1B

  tags = {
    Name = "Main-Public-Subnet2"
  }
}

resource "aws_subnet" "PrivateSubn1A" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone =var.AZ_1A               

  tags = {
    Name = "Private-Subnet1"
  }
}

resource "aws_subnet" "PrivateSubn2B" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone =var.AZ_1B

  tags = {
    Name = "Private-Subnet2"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main"
  }
}

#Nat Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.PublicSubn1.id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.gw]
}


#Route table
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block  = var.cidr
    gateway_id  = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "main-private" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block       = var.BIDEN_IP
    nat_gateway_id   = aws_nat_gateway.nat.id
  }      

  tags = {
    Name = "private"
  }
}

#Route table associations
resource "aws_route_table_association" "PublicSubn1-A" {
  subnet_id      = aws_subnet.PublicSubn1.id
  route_table_id = aws_route_table.main-public.id
}
resource "aws_route_table_association" "PublicSubn1-AB" {
  subnet_id      = aws_subnet.PublicSubn2.id
  route_table_id = aws_route_table.main-public.id
}
resource "aws_route_table_association" "PrivateSubn1-A" {
  subnet_id      = aws_subnet.PrivateSubn1A.id
  route_table_id = aws_route_table.main-private.id
}
resource "aws_route_table_association" "PrivateSubn1-B" {
  subnet_id      = aws_subnet.PrivateSubn2B.id
  route_table_id = aws_route_table.main-private.id
}

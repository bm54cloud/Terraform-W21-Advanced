#Create a custom VPC
resource "aws_vpc" "vpc-tf" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "terraform-vpc"
  }
}

#Obtain available availability zones
data "aws_availability_zones" "available-azs" {
  state = "available"
}

#Create public subnets in each available availability zone
resource "aws_subnet" "public-subnets-tf" {
  for_each                = var.public-subnets
  vpc_id                  = aws_vpc.vpc-tf.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, each.value + 100)
  availability_zone       = tolist(data.aws_availability_zones.available-azs.names)[each.value - 1]
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-subnet-public-${each.key}"
    Tier = "public"
  }
}

#Create private subnets in each available availability zone
resource "aws_subnet" "private-subnets-tf" {
  for_each                = var.private-subnets
  vpc_id                  = aws_vpc.vpc-tf.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, each.value)
  availability_zone       = tolist(data.aws_availability_zones.available-azs.names)[each.value - 1]
  map_public_ip_on_launch = false

  tags = {
    Name = "tf-subnet-private-${each.key}"
    Tier = "private"
  }
}

resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.vpc-tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "terraform_public_rtb"
    Tier = "public"
  }
}


#Create route table for private subnets 
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.vpc-tf.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = {
    Name = "terraform-private-rtb"
    Tier = "private"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = ["aws_vpc.vpc-tf.id"]
  }

  tags = {
    Tier = "public"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = ["aws_vpc.vpc-tf.id"]
  }

  tags = {
    Tier = "private"
  }
}

#Create public route table associations
resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public-subnets-tf]
  route_table_id = aws_route_table.public-rtb.id
  for_each       = aws_subnet.public-subnets-tf
  subnet_id      = each.value.id
}

#Create private route table associations
resource "aws_route_table_association" "private" {
  depends_on     = [aws_subnet.private-subnets-tf]
  route_table_id = aws_route_table.private-rtb.id
  for_each       = aws_subnet.private-subnets-tf
  subnet_id      = each.value.id
}

#Create Internet Gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc-tf.id
  tags = {
    Name = "terraform-igw"
  }
}

#Create EIP for NAT Gateway
resource "aws_eip" "nat-gateway-eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet-gateway]
  tags = {
    Name = "terraform-nat-gw-eip"
  }
}

#Create NAT Gateway
resource "aws_nat_gateway" "nat-gateway" {
  depends_on    = [aws_subnet.public-subnets-tf]
  allocation_id = aws_eip.nat-gateway-eip.id
  subnet_id     = aws_subnet.public-subnets-tf["public-subnet-1"].id
  tags = {
    Name = "terraform-nat-gw"
  }
}

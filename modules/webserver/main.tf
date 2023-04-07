#Create a custom VPC
resource "aws_vpc" "vpc-tf" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = var.tenancy
  enable_dns_hostnames = var.true
  enable_dns_support   = var.true

  tags = {
    Name = "terraform-vpc"
  }
}

#Obtain available availability zones
data "aws_availability_zones" "available-azs" {
  state = "available"
}

data "aws_subnet" "public-subnets-tf" {
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

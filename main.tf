module "ec2-instance" {
  source = "./modules"
}

module "security-group" {
  source = "./modules"
}

module "autoscaling" {
  source = "./modules"
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

locals {
  vpcs = tomap({
    for k, result in data.aws_subnets.public : k => {
      vpc_id = var.vpc-id
      subnet_ids = result.ids
    }
  })
}
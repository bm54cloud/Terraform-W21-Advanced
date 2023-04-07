variable "lt-name" {
  type    = string
  default = "terraform-lt"
}

variable "SSH" {
  type    = string
  default = "22"
}

variable "tcp" {
  type    = string
  default = "tcp"
}

variable "cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "HTTP" {
  type    = string
  default = "80"
}

variable "HTTPS" {
  type    = string
  default = "443"
}

variable "egress-all" {
  type    = string
  default = "0"
}

variable "egress" {
  type    = string
  default = "-1"
}

variable "ami" {
  description = "AMI"
  type        = string
  default     = "ami-0533def491c57d991"
}

variable "key_name" {
  description = "EC2 Key Name"
  type        = string
  default     = "EC2-Ohio"
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "vpc-cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public-subnets" {
  default = {
    "public-subnet-1" = 1
    "public-subnet-2" = 2
    "public-subnet-3" = 3
  }
}

variable "private-subnets" {
  default = {
    "private-subnet-1" = 1
    "private-subnet-2" = 2
    "private-subnet-3" = 3
  }
}

variable "instance-name-tag" {
  type    = string
  default = "Server from module"
}

variable "dev-tag" {
  type    = string
  default = "Development"
}
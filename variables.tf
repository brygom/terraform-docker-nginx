# AWS ACCESS KEY
variable "access_key" {
    description = "AWS user access key"
}

# AWS SECRET KEY
variable "secret_key" {
    description = "AWS user secret key"
}

# Infrastructure Version and Environment to keep track
variable "infrastructure_version" {
  description = "Version of Infrastructure"
  default     = 1
}

variable "environment" {
  description = "The environment currently on"
}

# CIDR Information for VPC, public subnets
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
}

# Current region to use
variable "region" {
  description = "The region to launch instances"
}

# Public Key to access EC2 instances
variable "key_name" {
  description = "The public key for EC2 instances"
}

# Total instances to provision
variable "instance_count" {
  description = "Total number of instances"
}

# The amis to use
variable "amis" {
  type        = "map"
  description = "The amis instances will use - ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180627"

  default = {
    "us-east-1" = "ami-759bc50a"
    "us-east-2" = "ami-5e8bb23b"
    "us-west-1" = "ami-4aa04129"
    "us-west-2" = "ami-ba602bc2"
  }
}

# Type of instance to launch
variable "instance_type" {
  description = "The instance type to launch"
}

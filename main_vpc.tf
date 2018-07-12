# Creating a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support  =  true
  enable_dns_hostnames = true

  tags {
    Name        = "${var.environment}-vpc"
    Environment = "${var.environment}-vpc"
    Version     = "${var.infrastructure_version}-vpc"
  }
}

# Create the internet gateway for public subnet
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.environment}-gw"
    Environment = "${var.environment}-gw"
    Version     = "${var.infrastructure_version}-gw"
  }
}

# Access the list of availability zones from region 
data "aws_availability_zones" "available" {}

# Create the public subnet 
resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.${count.index}.0/24"
  count                   = "${var.instance_count}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name        = "${var.environment}-public-subnet"
    Environment = "${var.environment}-public-subnet"
    Version     = "${var.infrastructure_version}-public-subnet"
  }
}

# Provides a list of subnet ids per the VPC id (for public)
data "aws_subnet_ids" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  depends_on = ["aws_subnet.public_subnet"]
}

# Create the routing table for the public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}-public-route-table"
    Version     = "${var.infrastructure_version}-public-route-table"
  }
}

# Create the route for the internet gateway for the public subnet
resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gw.id}"
  depends_on             = ["aws_route_table.public_rt"]
}

# Create the route table association for the public route table
resource "aws_route_table_association" "public_rta" {
  count          = "${var.instance_count}"
  subnet_id      = "${element(data.aws_subnet_ids.public.ids, count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

# Create the default security group for the VPC
resource "aws_security_group" "default_sg" {
  name        = "${var.environment}-vpc-default-sg"
  description = "The default security group to for VPC - allows inbound and outbound"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-vpc-default-sg"
    Environment = "${var.environment}-vpc-default-sg"
    Version     = "${var.infrastructure_version}-vpc-default-sg"
  }
}

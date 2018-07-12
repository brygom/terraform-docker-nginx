# Create security groups for the web instances which will be for the public subnets
resource "aws_security_group" "web_sg" {
  name        = "${var.environment}-web-sg"
  description = "The security group for the web, allowing traffic from internet as well as ssh"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Make sure hosts is pingable
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-web-sg"
    Environment = "${var.environment}-web-sg"
    Version	= "${var.infrastructure_version}-web-sg"
  }
}

# Create instances for the web
resource "aws_instance" "web" {
  count             = "${var.instance_count}"
  ami               = "${lookup(var.amis, var.region)}"
  instance_type     = "${var.instance_type}"
  subnet_id         = "${element(data.aws_subnet_ids.public.ids, count.index)}"

  vpc_security_group_ids      = ["${aws_security_group.web_sg.id}"]
  associate_public_ip_address = true

  key_name          = "${var.key_name}"
  user_data         = "${file("${path.module}/files/docker_nginx.sh")}"

  tags = {
    Name        = "${var.environment}-web-${count.index + 1}"
    Environment = "${var.environment}-web-${count.index + 1}"
    Version     = "${var.infrastructure_version}-web-${count.index + 1}"
  }
}


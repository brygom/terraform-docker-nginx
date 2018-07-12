# Create security group for Classic load balancer (elb)
resource "aws_security_group" "elb_sg" {
  name        = "${var.environment}-elb-sg"
  description = "The security group will allow HTTP traffic"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Makes sure host is pingable
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}-elb-sg"
    Environment = "${var.environment}-elb-sg"
    Version	= "${var.infrastructure_version}-elb-sg"
  }
}

# Create the Classic load balancer (ELB)
resource "aws_elb" "web" {
  name            = "${var.environment}-web-lb"
  subnets         = ["${data.aws_subnet_ids.public.ids}"]
  security_groups = ["${aws_security_group.elb_sg.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

    health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                 = ["${aws_instance.web.*.id}"]
  cross_zone_load_balancing = true

  tags {
    Name        = "${var.environment}-web-lb"
    Environment = "${var.environment}-web-lb"
    Version     = "${var.infrastructure_version}-web-lb"
  }
}

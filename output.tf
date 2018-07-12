# Output VPC id
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

# Output public subnet id
output "public_subnet_id" {
  value = "${data.aws_subnet_ids.public.ids}"
}

# Output default security group id
output "default_sg_id" {
  value = "${aws_security_group.default_sg.id}"
}

# Outputs the load balancer DNS name
output "elb.hostname" {
  value = "${aws_elb.web.dns_name}"
}


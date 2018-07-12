
# Terraform AWS Infrastructure

This repository contains a Terraform configuration that launches several public EC2 instances with one Classic Elastic Load Balancer.

## Project Structure and File Description
```
project
│   *README.md           
└───files
    │   *docker_nginx.sh --> Script to install Docker and Nginx Image
│   *main_aws.tf         --> AWS Provider and Key Pair
│   *main_ec2.tf         --> EC2 instances and ec2 security group
│   *main_lb.tf          --> Classic Elastic Load Balancer and elb security group
│   *main_vpc.tf         --> VPC, Subnets, Route Tables, Route Table Association and VPC security group 
│   *output.tf           --> Outputs VPC id, public subnet ids, security group id, and DNS name for elb
│   *terraform.tfstate   --> State of configuration 
│   *terraform.tfvars    --> Input variables (To change depending on AWS account)
│   *variables.tf        --> Defines variables
```
## Expectations
When terraform configuration is applied, a VPC is created along with public subnets and each subnet will have an EC2 instance that will provision a Nginx Docker container with an availability zone based on the region.
A public facing Classic Load Balancer is created to balance the instances.

## How to Use

### Requirements
To use terraform configuration, make sure you have the following:
- An AWS account
- AWS CLI installed
- terraform installed
- keypair created (to ssh into instances)

### Default Amis (Ubuntu 16.04)
- `us-east-1` = ami-759bc50a
- `us-east-2` = ami-5e8bb23b
- `us-west-1` = ami-4aa04129
- `us-west-2` = ami-ba602bc2

### Credentials and Setting Variables 
To start, replace all necessary variables in `terraform.tfvars` and if necessary, `variables.tf`.

#### Example:
Access key and secret key are provided from your AWS account
``` 
access_key = "ACCESS_KEY" 
```

### Launch Infrastructure
Run these terraform commands to launch the insfrastructure based on the configuration provided
```
$ terraform init
$ terraform plan
$ terraform apply
```
### Destroy Infrastructure
Run this terraform command to destroy the insfrastructure
```
$ terraform destroy
```
## Installation References
- [Terraform](https://www.terraform.io/intro/getting-started/install.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)
- `ssh-keygen -t rsa -C "keypair" -f ./keypair -P ""`

#### Notes:
- Configuration has been tested across all US regions

#!/bin/bash
# Install scripts for docker nginx container
# Reference: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04

# Adds the GPG key for the official Docker repository to the system
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository to APT sources
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the packages
apt-get update

# Making sure installing Docker from Repo instead of default Ubuntu 16.04 repo
apt-cache policy docker-ce

# Install Docker Community Edition
apt-get install -y docker-ce

# Pull the lastest Nginx image
docker pull nginx:latest

# Run the nginx container on port 80
docker run -d -p 80:80 --name nginx nginx

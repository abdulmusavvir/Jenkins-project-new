#!/bin/bash

# Install Java 17 (Amazon Corretto)
sudo echo "Installing Java 17 (Amazon Corretto)..."
sudo dnf install java-17-amazon-corretto -y

echo "Install Docker engine"
sudo yum update -y
sudo yum install docker -y
sudo usermod -aG docker ec2-user
sudo systemctl enable docker

echo "Install git"
sudo yum install -y git
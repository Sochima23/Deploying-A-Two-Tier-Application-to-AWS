#!/bin/bash

set -e

echo "Updating system packages..."
sudo apt update -y

# Check if Docker is installed
if command -v docker &> /dev/null
then
    echo "Docker is already installed"
else
    echo "Installing Docker..."

    sudo apt install -y docker.io

    sudo systemctl start docker
    sudo systemctl enable docker

    sudo usermod -aG docker ubuntu

    echo "Docker installation complete"
fi

# Check if Docker Compose is installed
if command -v docker-compose &> /dev/null
then
    echo "Docker Compose already installed"
else
    echo "Installing Docker Compose..."

    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose

    sudo chmod +x /usr/local/bin/docker-compose

    echo "Docker Compose installation complete"
fi

# Create application directory
echo "Creating application directories..."

mkdir -p ~/wordpress
sudo mkdir -p /mnt/mysql-data

# Check if EBS volume mounted
if mount | grep "/mnt/mysql-data" > /dev/null
then
    echo "EBS volume already mounted"
else
    echo "Mounting EBS volume..."

    sudo mount /dev/nvme1n1 /mnt/mysql-data
fi

# Set permissions
echo "Setting permissions..."

sudo chown -R ubuntu:ubuntu /mnt/mysql-data
sudo chmod -R 755 /mnt/mysql-data


echo "Provisioning completed successfully"

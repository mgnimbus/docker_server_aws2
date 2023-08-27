#!/bin/bash

# Installing docker
sudo yum update -y
sudo yum install docker -y

# Adding the user to the docker group to avoid using sudo for every docker cmd
sudo usermod -a -G docker ec2-user
sleep 5
newgrp docker

sudo systemctl enable docker.service
sudo systemctl start docker.service
sleep 5

if docker info >/dev/null 2>&1; then
    echo "Docker is running. Proceeding with setup..."
else
    echo "Docker is not running. Please start Docker and run this script again."
    exit 1
fi


:'
# self restarting mechanism
#!/bin/bash

sudo yum update -y
sudo yum install docker -y
sudo usermod -a -G docker ec2-user
# Switch to the docker group
newgrp docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
# Check if Docker is running
if docker info >/dev/null 2>&1; then
    echo "Docker is running. Proceeding with setup..."
else
    echo "Docker is not running. Waiting for a while before reattempting..."
    sleep 60  # Wait for 60 seconds

    # Re-run the script
    exec "$0"
    exit 0
fi
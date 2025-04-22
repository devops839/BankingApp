#!/bin/bash

# Step 1: Update the system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install Java & Maven
echo "Installing Java and Maven..."
sudo apt install -y openjdk-17-jdk maven

# Step 3: Install Docker
echo "Installing Docker..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
sudo chmod 666 /var/run/docker.sock
sudo usermod -aG docker $USER
newgrp docker

# Step 4: Install Trivy
echo "Installing Trivy..."
sudo snap install trivy

# Step 5: Install kubectl
echo "Installing kubectl..."
sudo apt-get install curl unzip -y
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl 
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Step 6: Install Azure CLI
echo "Installing Azure CLI..."
sudo apt-get install azure-cli

# Step 7: Install SonarQube (via Docker)
echo "Installing SonarQube..."
docker run -d --name sonarqube -p 9000:9000 sonarqube:community

echo "Tool installation completed!"

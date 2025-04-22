#!/bin/bash

# Step 1: Update the system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install Java & Maven
echo "Installing Java and Maven..."
sudo apt install openjdk-17-jdk -y
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
source ~/.bashrc
java -version

sudo apt install maven -y

# Step 3: Install Docker
echo "Installing Docker..."
sudo apt  install docker.io -y
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
sudo apt install curl -y
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl 
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Step 6: Install Azure CLI
echo "Installing Azure CLI..."
sudo apt update
sudo apt install ca-certificates curl apt-transport-https lsb-release gnupg

sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

AZ_REPO=$(lsb_release -cs)
echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt update
sudo apt install azure-cli

# Step 7: Install SonarQube (via Docker)
echo "Installing SonarQube..."
sudo apt install unzip jq -y
docker run -d --name sonarqube -p 9000:9000 sonarqube:community

echo "Tool installation completed!"

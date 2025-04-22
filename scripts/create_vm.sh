#!/bin/bash

# Variables
RESOURCE_GROUP="ci-cd-rg"
LOCATION="eastus"
VNET_NAME="ci-cd-vnet"
SUBNET_NAME="ci-cd-subnet"
NSG_NAME="ci-cd-nsg"
VM_NAME="gh-runner-vm"
VM_USERNAME="azureuser"                  
VM_PASSWORD="P@ssw0rd13579!"                
PUBLIC_IP_NAME="gh-runner-ip"
NIC_NAME="gh-runner-nic"

# Step 1: Create Resource Group
echo "Creating Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Step 2: Create VNet and Subnet
echo "Creating VNet and Subnet for VM..."
az network vnet create --resource-group $RESOURCE_GROUP --name $VNET_NAME --address-prefix 10.0.0.0/16 --subnet-name $SUBNET_NAME --subnet-prefix 10.0.1.0/24

# Step 3: Create NSG and Allow Required Ports (SSH, HTTP, HTTPS, SonarQube)
echo "Creating NSG and adding inbound rules..."
az network nsg create --resource-group $RESOURCE_GROUP --name $NSG_NAME

az network nsg rule create --resource-group $RESOURCE_GROUP --nsg-name $NSG_NAME --name AllowWeb --priority 100 --direction Inbound --access Allow --protocol Tcp --destination-port-ranges 22 80 443 9000 --source-address-prefixes '*' --destination-address-prefixes '*'

# Step 4: Create Public IP
echo "Creating Public IP..."
az network public-ip create --resource-group $RESOURCE_GROUP --name $PUBLIC_IP_NAME

# Step 5: Create NIC for VM
echo "Creating NIC for VM..."
az network nic create --resource-group $RESOURCE_GROUP --name $NIC_NAME --vnet-name $VNET_NAME --subnet $SUBNET_NAME --network-security-group $NSG_NAME --public-ip-address $PUBLIC_IP_NAME

# Step 6: Create VM with Username/Password Authentication
echo "Creating VM..."
az vm create \
  --resource-group $RESOURCE_GROUP --name $VM_NAME --nics $NIC_NAME --image Ubuntu2204 --admin-username $VM_USERNAME --admin-password $VM_PASSWORD --authentication-type password --size Standard_DS2_v2

echo "✅ VM creation completed!"

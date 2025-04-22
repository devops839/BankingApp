#!/bin/bash

# Variables
RESOURCE_GROUP="ci-cd-rg"
LOCATION="eastus"
VNET_NAME="ci-cd-vnet"
VNET_ADDRESS_PREFIX="10.0.0.0/16"
AKS_SUBNET_NAME="aks-subnet"
AKS_SUBNET_PREFIX="10.0.2.0/24"
ACR_NAME="cicdacr$RANDOM"         # Must be globally unique
AKS_NAME="ci-cd-aks"

# Step 1: Create Resource Group
echo "Creating Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Step 2: Create VNet and Subnet for AKS
echo "Creating VNet and AKS Subnet..."
az network vnet create --resource-group $RESOURCE_GROUP --name $VNET_NAME --address-prefix $VNET_ADDRESS_PREFIX --subnet-name $AKS_SUBNET_NAME --subnet-prefix $AKS_SUBNET_PREFIX

# Get Subnet ID
SUBNET_ID=$(az network vnet subnet show --resource-group $RESOURCE_GROUP --vnet-name $VNET_NAME --name $AKS_SUBNET_NAME --query id -o tsv)

# Step 3: Create Azure Container Registry (ACR)
echo "Creating Azure Container Registry (ACR)..."
az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Standard --location $LOCATION

# Step 4: Create Azure Kubernetes Service (AKS) in same VNet
echo "Creating AKS Cluster in same VNet..."
az aks create --resource-group $RESOURCE_GROUP --name $AKS_NAME --node-count 3 --enable-addons monitoring --generate-ssh-keys --vnet-subnet-id $SUBNET_ID --attach-acr $ACR_NAME --network-plugin azure --enable-managed-identity

# Step 5: Connect to AKS Cluster
echo "Connecting to AKS Cluster..."
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME

echo "✅ ACR and AKS created successfully in the same VNet!"

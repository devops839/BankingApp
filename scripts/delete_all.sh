#!/bin/bash

# Variables
RESOURCE_GROUP="ci-cd-rg"

# Step: Delete Resource Group
echo "Deleting resource group '$RESOURCE_GROUP' and all associated resources..."
az group delete --name $RESOURCE_GROUP --yes --no-wait

echo "🧹 Cleanup initiated!"

# === Configuration ===
$ResourceGroup = "ci-cd-rg"
$Location = "eastus"
$AcrName = "cicdacr20050"
$VnetName = "ci-cd-vnet"
$AksSubnetName = "aks-subnet"
$AksClusterName = "ci-cd-aks"
$AksNodeCount = 3
$AksNodeSize = "Standard_DS2_v2"
$AddressPrefix = "10.0.2.0/24"

# === Step 1: Create Azure Container Registry (ACR) ===
Write-Host "Creating Azure Container Registry (ACR)..."
az acr create `
  --name $AcrName `
  --resource-group $ResourceGroup `
  --location $Location `
  --sku Standard `
  --admin-enabled false `
  --output none
Write-Host "ACR '$AcrName' created."

# === Step 2: Create AKS Subnet ===
Write-Host "Creating AKS subnet in VNet '$VnetName'..."
az network vnet subnet create `
  --resource-group $ResourceGroup `
  --vnet-name $VnetName `
  --name $AksSubnetName `
  --address-prefixes $AddressPrefix `
  --output none
Write-Host "Subnet '$AksSubnetName' created in VNet '$VnetName'."

# === Step 3: Get AKS Subnet ID ===
Write-Host "Retrieving AKS Subnet ID..."
$SubnetId = az network vnet subnet show `
  --resource-group $ResourceGroup `
  --vnet-name $VnetName `
  --name $AksSubnetName `
  --query id `
  --output tsv
Write-Host "Subnet ID: $SubnetId"

# === Step 4: Create AKS Cluster ===
Write-Host "Creating AKS cluster '$AksClusterName'..."
az aks create `
  --resource-group $ResourceGroup `
  --name $AksClusterName `
  --node-count $AksNodeCount `
  --node-vm-size $AksNodeSize `
  --enable-addons monitoring `
  --generate-ssh-keys `
  --network-plugin azure `
  --vnet-subnet-id $SubnetId `
  --service-cidr 10.1.0.0/16 `
  --dns-service-ip 10.1.0.10 `
  --docker-bridge-address 172.17.0.1/16 `
  --output none
Write-Host "AKS Cluster '$AksClusterName' created."


# === Step 5: Attach ACR to AKS ===
Write-Host "Attaching ACR to AKS..."
az aks update `
  --name $AksClusterName `
  --resource-group $ResourceGroup `
  --attach-acr $AcrName `
  --output none
Write-Host "ACR attached to AKS."

# === Step 6: Connect to AKS ===
Write-Host "Connecting to AKS Cluster..."
az aks get-credentials `
  --name $AksClusterName `
  --resource-group $ResourceGroup `
  --overwrite-existing
Write-Host "Connected to AKS Cluster '$AksClusterName'."

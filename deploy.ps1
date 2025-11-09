# ReasonOS - Azure Deployment Script
# Run this script after making changes to deploy to Azure

Write-Host "🚀 ReasonOS Deployment to Azure" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Refresh PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Variables
$ACR_NAME = "reasonosregistry"
$BACKEND_IMAGE = "reasonosregistry.azurecr.io/backend:latest"
$FRONTEND_IMAGE = "reasonosregistry.azurecr.io/frontend:latest"

Write-Host "`n📦 Step 1: Building Docker Images..." -ForegroundColor Yellow

# Build Backend
Write-Host "Building backend..." -ForegroundColor Gray
Set-Location "C:\Users\sailo\ReasonOS\ReasonOS\backend"
docker build -t $BACKEND_IMAGE .
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Backend build failed!" -ForegroundColor Red
    exit 1
}

# Build Frontend
Write-Host "Building frontend..." -ForegroundColor Gray
Set-Location "C:\Users\sailo\ReasonOS\ReasonOS\frontend"
docker build -t $FRONTEND_IMAGE .
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`n✅ Step 1 Complete: Images built successfully!" -ForegroundColor Green

Write-Host "`n🔐 Step 2: Logging into Azure Container Registry..." -ForegroundColor Yellow
az acr login --name $ACR_NAME
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ ACR login failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`n📤 Step 3: Pushing Images to Azure..." -ForegroundColor Yellow

# Push Backend
Write-Host "Pushing backend..." -ForegroundColor Gray
docker push $BACKEND_IMAGE
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Backend push failed!" -ForegroundColor Red
    exit 1
}

# Push Frontend
Write-Host "Pushing frontend..." -ForegroundColor Gray
docker push $FRONTEND_IMAGE
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend push failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`n✅ Deployment Complete!" -ForegroundColor Green
Write-Host "🌐 Your app should update in 1-2 minutes" -ForegroundColor Cyan
Write-Host "`n📊 Monitor deployment:" -ForegroundColor Yellow
Write-Host "   az containerapp logs show --name reasonos-backend --resource-group rg-reasonos-prod --follow" -ForegroundColor Gray

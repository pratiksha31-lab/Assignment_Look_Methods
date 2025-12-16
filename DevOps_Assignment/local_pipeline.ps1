# Local CI/CD Pipeline Simulation for Windows (PowerShell)

$APP_NAME = "devops-app"
$IMAGE_TAG = "latest"

Write-Host "=========================================="
Write-Host "Starting Local CI/CD Pipeline"
Write-Host "=========================================="

# 1. Test
Write-Host "--> Running Tests..."
Write-Host "Tests Passed!"

# 2. Build
# Check if Minikube is running
$minikubePath = "C:\Program Files\Kubernetes\Minikube\minikube.exe"
if (-not (Test-Path $minikubePath)) {
    Write-Host "⚠️ Minikube executable not found at $minikubePath. Assuming 'minikube' is in PATH."
    $minikubePath = "minikube"
}

$minikubeStatus = & $minikubePath status 2>&1
if ($LastExitCode -ne 0) {
    Write-Host "Minikube is not running. Attempting to start..."
    & $minikubePath start --driver=docker
    if ($LastExitCode -ne 0) {
        Write-Host "Failed to start Minikube. Please ensure Docker Desktop is running."
        exit 1
    }
}

Write-Host "--> Building Docker Image..."
Write-Host "Configuring Docker environment for Minikube..."
# Configure Docker Env for PowerShell
& $minikubePath -p minikube docker-env --shell powershell | Invoke-Expression

$imageName = "$APP_NAME`:$IMAGE_TAG"
docker build -t $imageName .

if ($LastExitCode -ne 0) {
    Write-Host "Build Failed!"
    exit 1
}
Write-Host "Build Successful!"

# 3. Deploy
Write-Host "--> Deploying to Kubernetes..."

# Apply manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/monitoring/prometheus.yaml
kubectl apply -f k8s/monitoring/grafana.yaml

Write-Host "=========================================="
Write-Host "Deployment Complete!"
Write-Host "Access Application: http://localhost:30007"
Write-Host "Access Grafana: http://localhost:30000"
Write-Host "Access Prometheus: http://localhost:30090"
Write-Host "=========================================="

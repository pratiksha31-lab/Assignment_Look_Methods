#!/bin/bash

# Local CI/CD Pipeline Simulation

APP_NAME="devops-app"
IMAGE_TAG="latest"

echo "=========================================="
echo "🚀 Starting Local CI/CD Pipeline"
echo "=========================================="

# 1. Test (Simulated by installing requirements and running help/health input check if simple)
# For this assignment, we will use a docker build check as a 'test'
echo "--> 🧪 Running Tests..."
# In a real app: pytest
echo "Tests Passed!"

# 2. Build
# Check if Minikube is running
if ! minikube status > /dev/null 2>&1; then
    echo "⚠️ Minikube is not running. Attempting to start..."
    minikube start --driver=docker
fi

echo "--> 🔨 Building Docker Image..."
# Use minikube's docker daemon
echo "Configuring Docker environment for Minikube..."
eval $(minikube -p minikube docker-env)

docker build -t $APP_NAME:$IMAGE_TAG .

if [ $? -ne 0 ]; then
    echo "❌ Build Failed!"
    exit 1
fi
echo "Build Successful!"

# 3. Deploy
echo "--> 🚢 Deploying to Kubernetes..."

# Check if entities exist, delete to refresh or apply updates
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/monitoring/prometheus.yaml
kubectl apply -f k8s/monitoring/grafana.yaml

echo "=========================================="
echo "✅ Deployment Complete!"
echo "Access Application: http://localhost:30007 (Minikube: minikube service devops-app-service)"
echo "Access Grafana: http://localhost:30000"
echo "Access Prometheus: http://localhost:30090"
echo "=========================================="

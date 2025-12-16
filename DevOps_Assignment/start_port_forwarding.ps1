Write-Host "Starting Port Forwarding for DevOps App, Grafana, and Prometheus..."
Write-Host "This will open separate windows for each service. DO NOT CLOSE THEM."
Write-Host "--------------------------------------------------------"
Write-Host "Access URLs:"
Write-Host " - App:        http://localhost:30007"
Write-Host " - Grafana:    http://localhost:30000"
Write-Host " - Prometheus: http://localhost:30090"
Write-Host "--------------------------------------------------------"

# Open in separate windows so they persist even if this script finishes
Start-Process kubectl -ArgumentList "port-forward svc/devops-app-service 30007:80"
Start-Process kubectl -ArgumentList "port-forward svc/grafana-service 30000:3000"
Start-Process kubectl -ArgumentList "port-forward svc/prometheus-service 30090:9090"

Write-Host "Port forwarding processes started in new windows."
Read-Host -Prompt "Press Enter to exit this launcher script (Port forwards will keep running in their windows)"

Write-Host "Starting Port Forwarding for DevOps App, Grafana, and Prometheus..."
Write-Host "Keep this window OPEN to maintain access."
Write-Host "--------------------------------------------------------"
Write-Host "Access URLs:"
Write-Host " - App:        http://localhost:30007"
Write-Host " - Grafana:    http://localhost:30000"
Write-Host " - Prometheus: http://localhost:30090"
Write-Host "--------------------------------------------------------"

$p1 = Start-Process kubectl -ArgumentList "port-forward svc/devops-app-service 30007:80" -NoNewWindow -PassThru
$p2 = Start-Process kubectl -ArgumentList "port-forward svc/grafana-service 30000:3000" -NoNewWindow -PassThru
$p3 = Start-Process kubectl -ArgumentList "port-forward svc/prometheus-service 30090:9090" -NoNewWindow -PassThru

Write-Host "Port forwarding started. Press Ctrl+C to stop."
Wait-Process $p1, $p2, $p3

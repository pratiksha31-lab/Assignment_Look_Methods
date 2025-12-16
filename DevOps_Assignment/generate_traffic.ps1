$ErrorActionPreference = "SilentlyContinue"

Write-Host "Started Generating Traffic... (Press Ctrl+C to stop)"
Write-Host "Sending requests to http://localhost:30007/items ..."

$count = 0
while ($true) {
    $price = Get-Random -Minimum 10 -Maximum 100
    $body = @{
        name = "Item-$count"
        description = "This is item number $count"
        price = $price
    } | ConvertTo-Json

    # POST (Create item)
    Invoke-RestMethod -Uri "http://localhost:30007/items" -Method Post -Body $body -ContentType "application/json" | Out-Null
    
    # GET (List items) - multiple times to generate more read traffic
    Invoke-RestMethod -Uri "http://localhost:30007/items" -Method Get | Out-Null
    Invoke-RestMethod -Uri "http://localhost:30007/items" -Method Get | Out-Null

    $count++
    Write-Host -NoNewline "."
    if ($count % 10 -eq 0) { Write-Host "" }
    Start-Sleep -Milliseconds 500
}

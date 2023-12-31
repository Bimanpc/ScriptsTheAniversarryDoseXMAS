# Get all processes
$processes = Get-Process

# Display process information
foreach ($process in $processes) {
    Write-Host "Process Name: $($process.ProcessName), PID: $($process.Id), CPU: $($process.CPU), Memory: $($process.WorkingSet / 1MB) MB"
}

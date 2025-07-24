Write-Host "System Information Report"
Write-Host "=========================="

# Basic System Info
Write-Host "Hostname: $(hostname)"
Write-Host "Logged-in User: $env:USERNAME"
Write-Host "OS Version: $(Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty Caption)"
Write-Host "CPU: $(Get-CimInstance -ClassName Win32_Processor | Select-Object -ExpandProperty Name)"

# Network Info
Write-Host "IP Address: $(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -ne 'Loopback'} | Select-Object -First 1 -ExpandProperty IPAddress)"
$gw = Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null}
Write-Host "Default Gateway: $($gw.IPv4DefaultGateway.NextHop)"

# Uptime
Write-Host "Uptime: $((Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime)"

# Disk Info
$drive = Get-PSDrive C
$totalSpace = [math]::Round(($drive.Used + $drive.Free) / 1GB, 2)
$freeSpace = [math]::Round($drive.Free / 1GB, 2)
Write-Host "Total Disk Size (C:): $totalSpace GB"
Write-Host "Free Disk Space (C:): $freeSpace GB"

# Memory Info
$ramGB = [math]::Round(((Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB), 2)
Write-Host "Installed RAM: $ramGB GB"

# Battery Info (for laptops)
$battery = Get-CimInstance -ClassName Win32_Battery
if ($battery) {
    Write-Host "Battery Status: $($battery.BatteryStatus)"
    Write-Host "Battery Estimated Charge: $($battery.EstimatedChargeRemaining)%"
} else {
    Write-Host "Battery: Not detected"
}

# Pause before exit
Write-Host "`nPress any key to exit..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

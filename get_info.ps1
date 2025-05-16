# CPU Usage
$cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue

# RAM Usage
$ram = Get-WmiObject Win32_OperatingSystem
$memUsed = [math]::Round((($ram.TotalVisibleMemorySize - $ram.FreePhysicalMemory) / $ram.TotalVisibleMemorySize) * 100, 2)

# Disk Usage (C:)
$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"
$diskUsed = [math]::Round((($disk.Size - $disk.FreeSpace) / $disk.Size) * 100, 2)

# Read targetUrl from startup.bat
$startupFile = "C:\kiosk\startup.bat"
$targetUrl = "N/A"

if (Test-Path $startupFile) {
    $lines = Get-Content $startupFile
    foreach ($line in $lines) {
        if ($line -match 'set\s+targetUrl\s*=\s*"([^"]+)"') {
            $targetUrl = $matches[1]
            break
        }
    }
} else {
    Write-Warning "startup.bat not found at $startupFile"
}

# Output results
Write-Output "CPU Usage: $([math]::Round($cpu, 2))%"
Write-Output "RAM Usage: $memUsed%"
Write-Output "Disk C Usage: $diskUsed%"
Write-Output "Target URL: $targetUrl"

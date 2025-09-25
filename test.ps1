$build = (Get-CimInstance Win32_OperatingSystem).BuildNumber
if ([int]$build -ge 22000) {
    Write-Host "Windows 11"
} elseif ([int]$build -ge 10240) {
    Write-Host "Windows 10" 
} else {
    Write-Host "Not Windows 10/11"
}
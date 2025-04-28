$logPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\chrome_debug.log"

if (Test-Path $logPath) {
    $content = Get-Content $logPath -Raw
    if ($content -match "epn\.display_duration=90" -or $content -match "epn\.display_duration=91") {
        Write-Output "Found epn.display_duration=90 or epn.display_duration=91 in chrome_debug.log"
        exit 0
    } else {
        Write-Output "Not found."
        exit 1
    }
} else {
    Write-Output "Log file not found."
    exit 2
}

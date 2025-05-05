$logPath = "%TEMP%\ChromeKiosk\chrome_debug.log"

if (Test-Path $logPath) {
    # Check file size (in bytes)
    $fileSize = (Get-Item $logPath).Length
    $maxSize = 10MB  # 10 MB in bytes
    
    if ($fileSize -gt $maxSize) {
        # If file is too large, read just the last 2000 lines to avoid memory issues
        $lines = Get-Content $logPath -Tail 10000
        Write-Output "Warning: Log file is large ($([math]::Round($fileSize/1MB,2)) MB), only scanning last 10000 lines."
    } else {
        # For normal-sized files, read all content
        $lines = Get-Content $logPath
    }

    if ($lines.Count -gt 0) {
        $posterLine = $lines | Where-Object { $_ -match "poster_impression" } | Select-Object -Last 1
        
        if ($posterLine) {
            Write-Output $posterLine
        } else {
            Write-Output "No line containing 'poster_impression' found."
        }
    } else {
        Write-Output "Log file is empty."
    }
} else {
    Write-Output "Log file not found at $logPath"
}
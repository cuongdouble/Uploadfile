$logPath = "C:\Users\kioskuser\AppData\Local\Google\Chrome\User Data\chrome_debug.log"
if (Test-Path $logPath) {
    $lines = Get-Content $logPath

    if ($lines.Count -gt 0) {
        $posterLine = $lines | Where-Object { $_ -match "poster_impression" } | Select-Object -Last 1
        
        if ($posterLine) {
            Write-Output $posterLine
        } else {
            Write-Output "No line containing 'poster_impression' found."
        }
    }

}
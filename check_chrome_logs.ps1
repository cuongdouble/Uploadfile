$logPath = "C:\Users\kioskuser\AppData\Local\Google\Chrome\User Data\chrome_debug.log"
$lastPosterLine = $null

if (Test-Path $logPath) {
    $reader = [System.IO.StreamReader]::new($logPath)

    while (($line = $reader.ReadLine()) -ne $null) {
        if ($line -match "poster_impression") {
            $lastPosterLine = $line
        }
    }

    $reader.Close()

    if ($lastPosterLine) {
        Write-Output "Last line containing 'poster_impression':"
        Write-Output $lastPosterLine
    } else {
        Write-Output "No line containing 'poster_impression' found."
    }
} else {
    Write-Output "Log file not found."
}
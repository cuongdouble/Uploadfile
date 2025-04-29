$logPath = "C:\Users\kioskuser\AppData\Local\Google\Chrome\User Data\chrome_debug.log"
$posterLines = @()

if (Test-Path $logPath) {
    $reader = [System.IO.StreamReader]::new($logPath, [System.Text.Encoding]::UTF8)

    while (($line = $reader.ReadLine()) -ne $null) {
        if ($line -like "*poster_impression*") {
            $posterLines += $line
        }
    }

    $reader.Close()

    if ($posterLines.Count -gt 0) {
        $lastPosterLine = $posterLines[-1]
        Write-Output $lastPosterLine
    } else {
        Write-Output "No line containing 'poster_impression' found."
    }
} else {
    Write-Output "Log file not found."
}

$taskName = "CaptureScreenshot"
$scriptPath = "C:\iotedge\EFLOW-Shared\Scripts\click.ps1"
$user = "kioskuser"
$log = "C:\iotedge\logs\ps_task_log.txt"
function Log($msg) {
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$time $msg" | Out-File -Append -FilePath $log
}

Log "Creating task..."

& schtasks.exe /Create /TN $taskName `
    /TR "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`"" `
    /SC ONCE /ST 00:00 /RU $user /F | Out-Null

Log "Task created."

& schtasks.exe /Run /TN $taskName | Out-Null
Log "Task started."

Start-Sleep -Seconds 5

& schtasks.exe /Delete /TN $taskName /F | Out-Null
Log "Task deleted."

Log "Done."

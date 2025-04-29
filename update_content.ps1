$batFilePath = "C:\kiosk\startup.bat"
$content = Get-Content -Raw -Path $batFilePath
$content = $content -replace '--kiosk', '--kiosk --incognito'
Set-Content -Path $batFilePath -Value $content -Encoding UTF8
Write-Output "Replace completed successfully!"

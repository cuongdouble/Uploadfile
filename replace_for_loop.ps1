# Script to replace FOR loop from (1,1,200) to (1,1,40) in startup.bat
# File path
$filePath = "C:\kiosk\startup.bat"
$backupPath = "C:\kiosk\startup.bat.backup"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Replace FOR loop in startup.bat" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if file exists
if (-not (Test-Path $filePath)) {
    Write-Host "ERROR: File does not exist: $filePath" -ForegroundColor Red
    exit
}

Write-Host "File found: $filePath" -ForegroundColor Green
Write-Host ""

# Read file content
$content = Get-Content $filePath -Raw

# Check if the pattern exists
$pattern = 'FOR /L %%G IN \(1,1,200\)'
if ($content -notmatch $pattern) {
    Write-Host "WARNING: Pattern 'FOR /L %%G IN (1,1,200)' not found in file." -ForegroundColor Yellow
    Write-Host "No changes made." -ForegroundColor Yellow
    exit
}

Write-Host "Found pattern: FOR /L %%G IN (1,1,200)" -ForegroundColor Yellow
Write-Host ""

# Create backup
try {
    Copy-Item $filePath $backupPath -Force
    Write-Host "Backup created: $backupPath" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to create backup: $_" -ForegroundColor Red
    exit
}

Write-Host ""

# Replace the pattern
$newContent = $content -replace 'FOR /L %%G IN \(1,1,200\)', 'FOR /L %%G IN (1,1,40)'

# Write back to file
try {
    Set-Content -Path $filePath -Value $newContent -NoNewline
    Write-Host "SUCCESS: Replaced FOR /L %%G IN (1,1,200) with FOR /L %%G IN (1,1,40)" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to write to file: $_" -ForegroundColor Red
    Write-Host "Restoring from backup..." -ForegroundColor Yellow
    Copy-Item $backupPath $filePath -Force
    exit
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "NOTE: Backup file saved at: $backupPath" -ForegroundColor Cyan
Write-Host "You can delete the backup if everything works correctly." -ForegroundColor Cyan
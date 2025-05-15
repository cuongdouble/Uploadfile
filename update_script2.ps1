param(
    [Parameter(Mandatory = $true)]
    [string]$url,

    [Parameter(Mandatory = $true)]
    [string]$fileName
)

# Set default path if fileName is not an absolute path
if (-not ([System.IO.Path]::IsPathRooted($fileName))) {
    $defaultPath = "C:\iotedge\EFLOW-Shared\Scripts"
    
    # Create default directory if it doesn't exist
    if (-not (Test-Path $defaultPath)) {
        New-Item -Path $defaultPath -ItemType Directory -Force | Out-Null
    }
    
    $fileName = Join-Path -Path $defaultPath -ChildPath $fileName
}

try {
    # Download content from the specified URL
    $content = Invoke-WebRequest -Uri $url -UseBasicParsing
    $text = $content.Content

    # Overwrite or create the file with the downloaded content
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
	[System.IO.File]::WriteAllText($fileName, $text, $utf8NoBom)

    Write-Host "Content has been written to '$fileName'."
}
catch {
    Write-Error "Error: $_"
}
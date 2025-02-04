# Define the source folder
$sourceFolder = "C:\Users\sergi\Documents\IDMJI\Enseñanzas"
$destinationFolder = "$sourceFolder\GroupedFiles"

# Ensure the destination folder exists
if (-not (Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder | Out-Null
}

# Get all files in the source folder
$files = Get-ChildItem -Path $sourceFolder -File

# Helper function to extract a more precise group key
function Get-GroupKey($filename) {
    # Extract meaningful parts from the filename while keeping segments separate
    $key = $filename -replace '(IDMJI.*|_Spanish|_\d+kbit|transcript|Description|\.mp3|\.m4a|\.txt|\.jpg|\.srt)', ''
    $key = $key -replace '[^a-zA-Z0-9\s\(\)_-]', '' -replace '\s+', ' '
    
    # Identify and prioritize key terms (parts, dates)
    $tokens = $key.Split(' ')
    if ($tokens.Count -ge 5) {
        return ($tokens[0..5] -join '_').Trim()
    }
    return $key
}

# Group files by more precise keys
$groupedFiles = $files | Group-Object { Get-GroupKey $_.BaseName }

foreach ($group in $groupedFiles) {
    # Generate a clean folder name from the key
    $groupName = $group.Name -replace '[^\w\s]', '_' -replace '\s+', '_'
    $groupFolder = Join-Path $destinationFolder $groupName

    if (-not (Test-Path $groupFolder)) {
        New-Item -ItemType Directory -Path $groupFolder | Out-Null
    }

    # Move files to the corresponding group folder
    foreach ($file in $group.Group) {
        $destinationPath = Join-Path $groupFolder $file.Name
        Move-Item -Path $file.FullName -Destination $destinationPath
    }
}

Write-Host "Files have been successfully grouped and organized!"

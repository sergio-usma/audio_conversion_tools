# Define la carpeta ráiz
$RootPath = "C:\\ruta\\de\\los\\archivos"
$LogPath = "$PSScriptRoot\log_$(Get-Date -Format "yyyyMMdd_HHmmss").txt"
$CorruptFiles = [System.Collections.Generic.List[string]]::new()
$FileExtensions = [System.Collections.Generic.Dictionary[string, int]]::new()
$TotalFiles = 0
$CreatedFolders = 0

# Función para verificar si un archivo MP3 está corrupto
function Test-MP3File {
    param ($FilePath)
    try {
        $output = & C:\\ffmpeg\\ffmpeg -v error -i "$FilePath" -f null - 2>&1
        return -not ($output -match "Invalid" -or $output -match "error")
    } catch {
        return $false
    }
}

# Obtener todos los archivos en la carpeta ráiz
$Files = Get-ChildItem -Path $RootPath -File
$TotalFiles = $Files.Count

# Iniciar barra de progreso
$Index = 0
$GroupedFiles = @{}

foreach ($File in $Files) {
    $BaseName = $File.BaseName
    $TruncatedName = $BaseName.Substring(0, [math]::Ceiling($BaseName.Length * 0.75))
    
    if (-not $GroupedFiles.ContainsKey($TruncatedName)) {
        $GroupedFiles[$TruncatedName] = @()
    }
    $GroupedFiles[$TruncatedName] += $File
}

foreach ($Group in $GroupedFiles.GetEnumerator()) {
    $FolderName = $Group.Key
    $TargetFolder = Join-Path -Path $RootPath -ChildPath $FolderName
    
    if (-not (Test-Path $TargetFolder)) {
        New-Item -Path $TargetFolder -ItemType Directory | Out-Null
        $CreatedFolders++
    }
    
    foreach ($File in $Group.Value) {
        $Index++
        $Extension = $File.Extension.ToLower()
        
        # Contabilizar archivos por extensión
        if ($FileExtensions.ContainsKey($Extension)) {
            $FileExtensions[$Extension]++
        } else {
            $FileExtensions[$Extension] = 1
        }
        
        # Verificar si es un archivo MP3 y si está corrupto
        if ($Extension -eq ".mp3" -and -not (Test-MP3File -FilePath $File.FullName)) {
            $CorruptFiles.Add($File.FullName)
        }
        
        # Mover archivo a la carpeta correspondiente
        Move-Item -Path $File.FullName -Destination $TargetFolder -Force
        
        # Actualizar barra de progreso
        Write-Progress -Activity "Procesando archivos..." -Status "$Index de $TotalFiles" -PercentComplete (($Index / $TotalFiles) * 100)
    }
}

# Guardar log
$LogContent = @()
$LogContent += "Proceso finalizado: $(Get-Date)"
$LogContent += "Archivos leídos: $TotalFiles"
$LogContent += "Carpetas creadas: $CreatedFolders"
$LogContent += "Archivos corruptos: $($CorruptFiles.Count)"
$LogContent += ""
foreach ($Ext in $FileExtensions.Keys) {
    $LogContent += "Archivos ${Ext}: $($FileExtensions[$Ext])"
}
$LogContent | Out-File -FilePath $LogPath -Encoding utf8

# Mostrar resumen en consola
Write-Output "--- Resumen del proceso ---"
Write-Output "Archivos leídos: $TotalFiles"
Write-Output "Carpetas creadas: $CreatedFolders"
Write-Output "Archivos corruptos: $($CorruptFiles.Count)"
foreach ($Ext in $FileExtensions.Keys) {
    Write-Output "Archivos ${Ext}: $($FileExtensions[$Ext])"
}

if ($CorruptFiles.Count -gt 0) {
    Write-Output "--- Archivos corruptos ---"
    $CorruptFiles | ForEach-Object { Write-Output $_ }
}

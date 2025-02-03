param (
    [string]$RootDirectory = (Get-Location).Path
)

# Mover archivos desde subcarpetas al directorio raíz
Get-ChildItem -Path $RootDirectory -Recurse -File | ForEach-Object {
    $destination = Join-Path -Path $RootDirectory -ChildPath $_.Name
    try {
        Move-Item -Path $_.FullName -Destination $destination -Force
        Write-Host "Movido: $($_.FullName) a $destination" -ForegroundColor Green
    } catch {
        Write-Host "Error moviendo el archivo: $($_.FullName)" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}

# Eliminar carpetas vacías
Get-ChildItem -Path $RootDirectory -Recurse -Directory | Sort-Object FullName -Descending | ForEach-Object {
    if (!(Get-ChildItem -Path $_.FullName -Recurse)) {
        try {
            Remove-Item -Path $_.FullName -Force -Recurse
            Write-Host "Eliminada carpeta vacía: $($_.FullName)" -ForegroundColor Yellow
        } catch {
            Write-Host "Error eliminando la carpeta: $($_.FullName)" -ForegroundColor Red
            Write-Host $_.Exception.Message
        }
    }
}

if (-not $global:WorkingDirectory) {
    Write-Host "Ingen arbetsmapp vald. Välj en mapp först."
    return
}

# Skapa undermapp för export om den inte finns
$exportFolder = Join-Path $global:WorkingDirectory "dataflow_exports"
if (-not (Test-Path $exportFolder)) {
    New-Item -ItemType Directory -Path $exportFolder | Out-Null
    Write-Host "Skapade mapp: $exportFolder"
} else {
    Write-Host "Exportmapp finns redan: $exportFolder"
}

# Hämta alla dataflöden
$dataflows = Get-PowerBIDataflow -Scope Organization

foreach ($df in $dataflows) {
    $id = $df.Id
    $name = $df.Name -replace '[\\/:*?"<>|]', '_'
    $outfileName = "$name $id.json"
    $outfile = Join-Path $exportFolder $outfileName

    Export-PowerBIDataflow -Id $id -Scope Organization -OutFile $outfile
    Write-Host "Exporterade: $outfile"
}
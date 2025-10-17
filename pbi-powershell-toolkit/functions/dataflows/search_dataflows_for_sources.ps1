if (-not $global:WorkingDirectory) {
    Write-Host "Ingen arbetsmapp vald. Välj en mapp först."
    return
}

$folderPath = Join-Path $global:WorkingDirectory "dataflow_exports"
if (-not (Test-Path $folderPath)) {
    Write-Host "Mappen med exporterade dataflöden saknas: $folderPath"
    return
}

Write-Host "Läser JSON-filer från: $folderPath"

$output = @()
$jsonFiles = Get-ChildItem -Path $folderPath -Filter *.json

foreach ($file in $jsonFiles) {
    $content = Get-Content $file.FullName -Raw

    # Extrahera ID från filnamnet (sista delen före .json)
    $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $parts = $fileNameWithoutExtension -split ' '
    $dataflowId = $parts[-1]
    $dataflowName = ($parts[0..($parts.Length - 2)] -join ' ')

    # Matcha escaped Schema och Item
    $pattern = "\[Schema\s*=\s*\\""(?<Schema>[^\""]+)\\"",\s*Item\s*=\s*\\""(?<Item>[^\""]+)\\""\]"

    $found_matches = [regex]::Matches($content, $pattern)

    # [Schema = \"dbo\", Item = \"employment\"]

    foreach ($match in $found_matches) {
        $output += [PSCustomObject]@{
            "Dataflow name" = $dataflowName
            "Dataflow ID"   = $dataflowId
            Schema          = $match.Groups["Schema"].Value
            Table           = $match.Groups["Item"].Value
        }
    }
}

if ($output.Count -gt 0) {
    $csvPath = Join-Path $global:WorkingDirectory "ExtractedTables.csv"

    # Exportera med UTF8-BOM för att stödja svenska tecken
    $utf8WithBom = New-Object System.Text.UTF8Encoding $true
    $csvContent = $output | ConvertTo-Csv -NoTypeInformation
    [System.IO.File]::WriteAllLines($csvPath, $csvContent, $utf8WithBom)

    Write-Host "CSV-fil sparad till: $csvPath"
}
else {
    Write-Host "Inga Schema/Item-referenser hittades i JSON-filerna."
}
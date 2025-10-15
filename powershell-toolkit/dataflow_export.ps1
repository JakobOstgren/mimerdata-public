Connect-PowerBIServiceAccount

Add-Type -AssemblyName System.Windows.Forms

$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowser.Description = "Chose a folder where the dataflows will be exported"
$folderBrowser.ShowNewFolderButton = $true

if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $exportPath = $folderBrowser.SelectedPath
    Write-Host "Exportmapp vald: $exportPath"

    # Get all dataflows
    $dataflows = Get-PowerBIDataflow -Scope Organization

    foreach ($df in $dataflows) {
        $id = $df.Id
        $name = $df.Name -replace '[\\/:*?"<>|]', '_'
        $outfile = Join-Path $exportPath "$name.json"

        Export-PowerBIDataflow -Id $id -Scope Organization -OutFile $outfile
    }
} else {
    Write-Host "No folder was chosen. Script it being terminated."
}
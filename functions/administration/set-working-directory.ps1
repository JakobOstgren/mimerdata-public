Add-Type -AssemblyName System.Windows.Forms

    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Välj arbetsmapp för export och andra funktioner"
    $folderBrowser.ShowNewFolderButton = $true

    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $global:WorkingDirectory = $folderBrowser.SelectedPath
        Write-Host "Arbetsmapp vald: $WorkingDirectory"
    } else {
        Write-Host "Ingen mapp valdes."
    }
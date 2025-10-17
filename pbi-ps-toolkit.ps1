# 0. Global variables
$global:WorkingDirectory = ""

## Main menu
function Show-Menu {
    Clear-Host
    Write-Host "==============================="
    Write-Host " Power BI Powershell Toolkit by Mimer Data Solutions"
    Write-Host "==============================="
    Write-Host "0. Avsluta"
    Write-Host "1. Administration"
    Write-Host "2. Dataflöden"
    Write-Host "3. Lokala data gateways"
    Write-Host ""
}
function Pause {
    Write-Host ""
    Read-Host "Tryck [Enter] för att återgå till menyn"
}

### Administration (sub-menu)
function Show-AdministrationMenu {
    Clear-Host
    Write-Host "==============================="
    Write-Host " Administration"
    Write-Host "==============================="
    Write-Host "0. Tillbaka till huvudmenyn"
    Write-Host "1. Välj en arbetsmapp"
    Write-Host "2. Anslut till Power BI"
    Write-Host "3. Få ett API-token genom OAUTH"
    Write-Host ""
}
function HandleAdministrationMenu {
    $continue = $true
    while ($continue) {
        Show-AdministrationMenu
        $choice = Read-Host "Välj ett alternativ"

        switch ($choice) {
            "0" { $continue = $false }
            "1" { . "$PSScriptRoot\Functions\administration\set-working-directory.ps1"; Pause }
            "2" { . "$PSScriptRoot\Functions\administration\connect-pbi.ps1"; Pause }
            "3" { . "$PSScriptRoot\Functions\administration\get-token-oauth.ps1"; Pause }
            default { Write-Host "Ogiltigt val. Försök igen."; Pause }
        }
    }
}

### Dataflows (sub-menu)
function Show-DataflowMenu {
    Clear-Host
    Write-Host "==============================="
    Write-Host " Dataflödesfunktioner"
    Write-Host "==============================="
    Write-Host "0. Tillbaka till huvudmenyn"
    Write-Host "1. Lista alla dataflöden"
    Write-Host "2. Exportera alla dataflöden som JSON-filer"
    Write-Host "3. Sök igenom exporterade JSON-filer efter referenser till SQL-databas-tabeller."
    Write-Host ""
}
function HandleDataflowMenu {
    $continue = $true
    while ($continue) {
        Show-DataflowMenu
        $choice = Read-Host "Välj ett alternativ"

        switch ($choice) {
            "0" { $continue = $false }
            "1" { . "$PSScriptRoot\Functions\dataflows\get_dataflows.ps1"; Pause }
            "2" { . "$PSScriptRoot\Functions\dataflows\export_dataflows.ps1"; Pause }
            "3" { . "$PSScriptRoot\Functions\dataflows\search_dataflows_for_sources.ps1"; Pause }
            default { Write-Host "Ogiltigt val. Försök igen."; Pause }
        }
    }
}

### Gateways (sub-menu)
function Show-GatewayMenu {
    Clear-Host
    Write-Host "==============================="
    Write-Host " Funktioner för lokala data gateways"
    Write-Host "==============================="
    Write-Host "0. Tillbaka till huvudmenyn"
    Write-Host "1. Lista alla lokala data gateways"
    Write-Host ""
}
function HandleGatewaysMenu {
    $continue = $true
    while ($continue) {
        Show-GatewayMenu
        $choice = Read-Host "Välj ett alternativ"

        switch ($choice) {
            "0" { $continue = $false }
            "1" { . "$PSScriptRoot\Functions\gateways\get_gateways.ps1"; Pause }
            default { Write-Host "Ogiltigt val. Försök igen."; Pause }
        }
    }
}

# Main loop
do {
    Show-Menu
    $choice = Read-Host "Välj ett alternativ"

    switch ($choice) {
        "0" { Write-Host "Avslutar..."; exit }
        "1" { HandleAdministrationMenu }
        "2" { HandleDataflowMenu }
        "3" { HandleGatewaysMenu }
        default { Write-Host "Ogiltigt val. Försök igen."; Pause }
    }

} while ($true)
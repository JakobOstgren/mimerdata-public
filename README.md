# powershell-toolkit
Here I store useful Powershell scripts that I run against Fabric to make my life easier.

### Prerequisites
- [Registered app in Azure for authentication against Power BI.](https://learn.microsoft.com/en-us/power-bi/developer/embedded/register-app)
- Entra-account with access to Azure Key Vault where app-secrets are stored.
- [Az-KeyVault Powershell module](https://www.powershellgallery.com/packages/Az.Keyvault/6.3.2)
- JSON-file with configuration settings. See [example file](/powershell-toolkit/powershell-toolkit-configuration-file.json).


# pbiatlas –  Fabric/Power BI metadata retrieval and storage
pbiatlas is a pre-built solution consisting of Fabric objects that retrieves and stores information about metadata and user activity in your **Fabric/Power BI domain**. It uses the **Power BI REST API** to collect data and builds on Fabric components for storage, transformation, and visualization.

pbiatlas provides insights such as name, id, creation, modification, lineage, content, etc. into objects within the organization's Power BI or Fabric domain. See [metadata-structure_workspaces](/pbiatlas/metadata-structure_workspaces.txt) for a complete list of data points that are being collected.

### How it works

A Fabric Pipeline will make an API-call to the Entra, asking permission to use a registered app (prerequisite) in Azure. This registered app in turn has permission to call and receive information from the organisations Fabric tenant. Having received a token representing the registered app, a new API-call is made, this time to the Fabric tenant, requesting information about workspaces and their content. The information is stored in stored in a Lakehouse (prequisite) of your choise.

### Configuration File
THe first thing the Fabric pipeline is set to do is to call a configuration file containing necessary parameters for connections and identification (e.g., workspaces, client ID, secrets). This file must be filled in by the user and stored somewhere the Fabric pipeline can reach it; preferably a Lakehouse or Storage account.

This first step in the pipeline must also be configured by the user so that the pipeline can find and read the configuration file. The configuration file needs to follow the format specified in the [example file](/pbiatlas/configuration-file.json).

### Prerequisites
- Azure App Registration
    - The app has a client secret but **no API permissions** in the Power BI Service.
    - The app must be part of a **security group** that has access to the workspaces to be scanned.
- Azure Key Vault
    - When calling the Entra API to receive a token usable in the Fabric REST-API, the solution will need to identify itself as the registered app. The authentication necessary must be stored in an Azure Key Vault reachable from the workspace where the solution is deployed.
- Fabric
    - The app requires the following permissions set up in the portal:
        - Service principal has access to read-only admin APIs  
        - Service principal has access to refresh APIs  
        - Extended API responses with detailed metadata  
        - Extended responses with DAX and mashup expressions
    - The app must also have read-access to all workspaces you want to scan.

---
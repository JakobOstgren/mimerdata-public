# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {}
# META }

# PARAMETERS CELL ********************

# Läs in parameter från pipeline
vault_name = "your-vault-name-here"
secret_name_for_tenant_id = "secret-name-for-tenant-id-here"
secret_name_for_client_id = "secret-name-for-client-id-here"
secret_name_for_secret_key = "secret-key-name-here"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

import notebookutils

# Hämta testhemligheten från Key Vault
my_vault = f"https://{vault_name}.vault.azure.net/"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Hämta hemligheter från Key Vault
tenant_id = notebookutils.credentials.getSecret(my_vault, secret_name_for_tenant_id)
client_id = notebookutils.credentials.getSecret(my_vault, secret_name_for_client_id)
client_secret = notebookutils.credentials.getSecret(my_vault, secret_name_for_secret_key)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Bygg URL och headers
url = f"https://login.microsoftonline.com/{tenant_id}/oauth2/token"
headers = {
    "Content-Type": "application/x-www-form-urlencoded"
}

# Bygg meddelandetext (form-data)
payload = (
    f"grant_type=client_credentials"
    f"&client_id={client_id}"
    f"&client_secret={client_secret}"
    f"&scope=openid%20offline_access"
    f"&resource=https://analysis.windows.net/powerbi/api"
)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

import requests

# Gör POST-anropet
response = requests.post(url, data=payload, headers=headers)

# Visa token eller fel
if response.status_code == 200:
    access_token = response.json().get("access_token")
else:
    print("Fel vid token-anrop:", response.status_code)
    print(response.text)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

mssparkutils.notebook.exit(access_token)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

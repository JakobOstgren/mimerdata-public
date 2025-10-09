# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse_name": "",
# META       "default_lakehouse_workspace_id": "",
# META       "known_lakehouses": []
# META     }
# META   }
# META }

# PARAMETERS CELL ********************

#During testing you can put a token here. If there is a token in the pipeline parameter, the information there will be overwritten"
access_token = "your-access-token-here"
workspace_id = "your-workspace-id-here"
lakehouse_id = "your-lakehouse-id-here"
lakehouse_file_path = "your-lakehouse-file-path-here"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

import requests

# Hämta arbetsytor att scanna. Hämtar allt förutom personliga arbetsytor.
url = "https://api.powerbi.com/v1.0/myorg/admin/workspaces/modified?excludePersonalWorkspaces=True"

headers = {
    "Authorization": f"Bearer {access_token}",
    "Content-Type": "application/json"
}

response = requests.get(url, headers=headers)
data = response.json()
print(data)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Konstruera anropet

# API URL
url = "https://api.powerbi.com/v1.0/myorg/admin/workspaces/getInfo" #?lineage=True&datasourceDetails=True&datasetSchema=True&datasetExpressions=True
 
# Headers
headers = {
    "Authorization": f"Bearer {access_token}",
    "Content-Type": "application/json"
}

# Body
body = {
    "workspaces": [item["id"] for item in data]
}

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# POST-anrop
response = requests.post(url, headers=headers, json=body)

# Kontrollera status och extrahera ID
if response.status_code == 202:
    result = response.json()
    scan_id = result["id"]
else:
    print(f"Fel: {response.status_code}")
    print(response.text)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

import json
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType
from io import StringIO

# Bygg URL och headers
base_url = "https://api.powerbi.com/v1.0/myorg/admin/workspaces/scanResult/"
full_url = f"{base_url}{scan_id}"
headers = {
    "Authorization": f"Bearer {access_token}"
}

# Gör API-anrop
response = requests.get(full_url, headers=headers)
response.raise_for_status()  # kastar fel om något går snett

# Ladda JSON-data
data = response.json()

# Konvertera till DataFrame
spark = SparkSession.builder.getOrCreate()
df = spark.read.json(sc.parallelize([json.dumps(data)]))

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from datetime import datetime

# Skapa ett tidsstämplat filnamn
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
filename = f"pbimetadata_{timestamp}.parquet"

# Sökväg till Lakehouse
lakehouse_path = f"abfss://{workspace_id}@onelake.dfs.fabric.microsoft.com/{lakehouse_id}/Files/{lakehouse__file_path}/{filename}"

# Skriv till OneLake
df.write.mode("overwrite").parquet(lakehouse_path)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

from azure.storage.blob import BlobServiceClient
import os

account_url = "https://stlakesupply.blob.core.windows.net"
account_key = "yourKeyHere"  # Replace with your actual key
local_data_folder = "supplyChain_db"

blob_service = BlobServiceClient(account_url=account_url, credential=account_key)

print("Uploading data files to source-files...")
for root, dirs, files in os.walk(local_data_folder):
    for file_name in files:
        local_path = os.path.join(root, file_name)
        blob_client = blob_service.get_blob_client(container="source-files", blob=file_name)
        with open(local_path, "rb") as data:
            blob_client.upload_blob(data, overwrite=True)
        print(f"  Uploaded: {local_path} -> source-files/{file_name}")
print("Data files uploaded!\n")
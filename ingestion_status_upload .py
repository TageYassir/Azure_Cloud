from azure.storage.blob import BlobServiceClient
import csv

account_url = "https://stlakesupply.blob.core.windows.net"
account_key = "yourKeyHere"  # Replace with your actual key

blob_service = BlobServiceClient(account_url=account_url, credential=account_key)

# Create control CSV locally
print("Creating control file...")
with open("ingestion_status.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["source_file_name", "source_container", "source_name", "ingestion_status", "ingestion_time", "error_message"])
    writer.writerow(["suppliers.csv", "source-files", "suppliers", "Pending", "", ""])
    writer.writerow(["purchase_orders.csv", "source-files", "purchase_orders", "Pending", "", ""])
    writer.writerow(["deliveries.csv", "source-files", "deliveries", "Pending", "", ""])
    writer.writerow(["inventory.csv", "source-files", "inventory", "Pending", "", ""])

# Upload to ADLS
print("Uploading control file to medallion/control/...")
blob_client = blob_service.get_blob_client(container="medallion", blob="control/ingestion_status.csv")
with open("ingestion_status.csv", "rb") as data:
    blob_client.upload_blob(data, overwrite=True)
print("Control file uploaded!\n")

print("Done! Check medallion/control/ingestion_status.csv in Azure Portal.")
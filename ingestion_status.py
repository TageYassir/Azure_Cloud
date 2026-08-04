import csv

with open('ingestion_status.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['source_file_name', 'source_container', 'source_name', 'ingestion_status', 'ingestion_time', 'error_message'])
    writer.writerow(['suppliers.csv', 'source-files', 'suppliers', 'Pending', '', ''])
    writer.writerow(['purchase_orders.csv', 'source-files', 'purchase_orders', 'Pending', '', ''])
    writer.writerow(['deliveries.csv', 'source-files', 'deliveries', 'Pending', '', ''])
    writer.writerow(['inventory.csv', 'source-files', 'inventory', 'Pending', '', ''])

print("Created ingestion_status.csv")
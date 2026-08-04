import csv
import os
import random
from datetime import date, timedelta

# ================== CONFIGURATION ==================
BASE_DIR = "supplyChain_db"
START_DATE = date(2026, 8, 1)
NUM_DAYS = 4                        # 4 daily snapshots

# Master data sizes
NUM_SUPPLIERS = 200
NUM_PRODUCTS = 50
NUM_WAREHOUSES = 5
ORDERS_PER_DAY = 250                # ~1000 total across 4 days
DELIVERIES_PER_DAY = int(ORDERS_PER_DAY * 0.8)  # 80% of orders get a delivery

# Static lists for generating realistic values
COUNTRIES = ['USA','Germany','Japan','France','UK','China','India','Brazil','Mexico','Canada']
REGIONS = ['AMER','EMEA','APAC']
SUPPLIER_CATEGORIES = ['Strategic','Preferred','Tactical']
PRODUCT_NAMES = [
    'Engine Filter', 'Brake Pad Set', 'LED Headlight', 'Oil Filter', 'Spark Plug',
    'Battery 12V', 'Alternator', 'Starter Motor', 'AC Compressor', 'Radiator',
    'Water Pump', 'Fuel Pump', 'Shock Absorber', 'Control Arm', 'Ball Joint',
    'CV Axle', 'Wheel Bearing', 'Brake Rotor', 'Brake Caliper', 'Drive Belt',
    'Timing Belt', 'Ignition Coil', 'Mass Airflow Sensor', 'Oxygen Sensor', 'EGR Valve',
    'Turbocharger', 'Intercooler', 'Fuel Injector', 'Glow Plug', 'Camshaft Sensor',
    'Crankshaft Sensor', 'Throttle Body', 'Fuel Filter', 'Cabin Air Filter', 'Transmission Filter',
    'Clutch Kit', 'Flywheel', 'Pressure Plate', 'Slave Cylinder', 'Master Cylinder',
    'ABS Sensor', 'Wheel Speed Sensor', 'Steering Rack', 'Power Steering Pump', 'Tie Rod End',
    'Sway Bar Link', 'Strut Mount', 'Coil Spring', 'Leaf Spring', 'U-Joint'
]
PRODUCT_CATEGORIES = ['Filters','Brakes','Electronics','Engine Parts','Suspension','Transmission']
WAREHOUSE_LOCATIONS = ['Paris','Berlin','New York','Tokyo','Mumbai']
STATUS_ORDER = ['Open','Closed','Cancelled','Partially Shipped']
DELIVERY_STATUS = ['OnTime','Late','Early','Partial']

random.seed(42)  # reproducible

# ================== HELPER FUNCTIONS ==================
def generate_suppliers(num):
    rows = []
    for i in range(1, num+1):
        sid = f"SUP{str(i).zfill(4)}"
        name = f"Supplier_{i}"
        country = random.choice(COUNTRIES)
        if country in ['USA','Mexico','Canada','Brazil']:
            region = 'AMER'
        elif country in ['Germany','France','UK']:
            region = 'EMEA'
        else:
            region = 'APAC'
        category = random.choice(SUPPLIER_CATEGORIES)
        lead_time = random.randint(1, 30)
        quality_score = round(random.uniform(1.0, 5.0), 2)
        rows.append([sid, name, country, region, category, lead_time, quality_score])
    return rows

def generate_products(num):
    rows = []
    for i in range(1, num+1):
        pid = f"P{str(i).zfill(4)}"
        pname = PRODUCT_NAMES[i % len(PRODUCT_NAMES)] + f" #{i}"
        cat = PRODUCT_CATEGORIES[i % len(PRODUCT_CATEGORIES)]
        rows.append([pid, pname, cat])
    return rows

def generate_warehouses(num):
    rows = []
    for i in range(1, num+1):
        wid = f"WH{str(i).zfill(2)}"
        loc = WAREHOUSE_LOCATIONS[i % len(WAREHOUSE_LOCATIONS)]
        reg = 'EMEA' if loc in ['Paris','Berlin'] else ('AMER' if loc=='New York' else 'APAC')
        rows.append([wid, f"Warehouse {loc}", loc, reg])
    return rows

def generate_orders(day, num_orders, suppliers, products, warehouses):
    rows = []
    for j in range(1, num_orders+1):
        oid = f"ORD{day.strftime('%Y%m%d')}{str(j).zfill(5)}"
        supplier = random.choice(suppliers)
        product = random.choice(products)
        warehouse = random.choice(warehouses)
        qty = random.randint(10, 500)
        unit_cost = round(random.uniform(5.0, 500.0), 2)
        total = round(qty * unit_cost, 2)
        status = random.choice(STATUS_ORDER)
        # order_date is the snapshot day (or a day before)
        order_date = (day - timedelta(days=random.randint(0,2))).isoformat()
        rows.append([oid, supplier[0], product[0], warehouse[0], order_date, qty, unit_cost, total, status])
    return rows

def generate_deliveries(day, num_deliveries, orders_today, suppliers, products, warehouses):
    rows = []
    # deliveries only for orders that are closed or partially shipped
    eligible_orders = [o for o in orders_today if o[8] in ('Closed','Partially Shipped')]
    if len(eligible_orders) < num_deliveries:
        eligible_orders = orders_today[:num_deliveries]  # fallback
    selected = random.sample(eligible_orders, min(num_deliveries, len(eligible_orders)))
    for i, order in enumerate(selected):
        did = f"DEL{day.strftime('%Y%m%d')}{str(i+1).zfill(5)}"
        order_id = order[0]
        qty_ordered = int(order[5])
        qty_delivered = random.randint(0, qty_ordered)
        qty_accepted = random.randint(0, qty_delivered)
        qty_rejected = qty_delivered - qty_accepted
        delivery_status = random.choice(DELIVERY_STATUS)
        actual_delivery_date = (day + timedelta(days=random.randint(0,3))).isoformat()
        carrier = random.choice(['DHL','FedEx','UPS','Maersk','DB Schenker'])
        rows.append([did, order_id, actual_delivery_date, qty_delivered, qty_accepted, qty_rejected, delivery_status, carrier])
    return rows

def generate_inventory(day, products, warehouses, prev_inventory=None):
    rows = []
    if prev_inventory is None:
        # initial stock
        for w in warehouses:
            for p in products:
                rows.append([w[0], p[0], random.randint(50, 500)])
    else:
        # simulate small daily changes (±5%)
        prev_dict = { (r[0], r[1]): r[2] for r in prev_inventory }
        for w in warehouses:
            for p in products:
                key = (w[0], p[0])
                qty = prev_dict.get(key, random.randint(50,500))
                delta = random.randint(-int(qty*0.05), int(qty*0.05))
                new_qty = max(0, qty + delta)
                rows.append([w[0], p[0], new_qty])
    return rows

# ================== MAIN GENERATION ==================
suppliers = generate_suppliers(NUM_SUPPLIERS)
products = generate_products(NUM_PRODUCTS)
warehouses = generate_warehouses(NUM_WAREHOUSES)

prev_inventory = None
for day_offset in range(NUM_DAYS):
    current_day = START_DATE + timedelta(days=day_offset)
    day_folder = os.path.join(BASE_DIR, current_day.strftime('%Y/%m/%d'))
    os.makedirs(day_folder, exist_ok=True)

    # 1. Suppliers (static, same every day)
    with open(os.path.join(day_folder, 'suppliers.csv'), 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(['supplier_id','supplier_name','country','region','category','lead_time_days','quality_score'])
        w.writerows(suppliers)

    # 2. Purchase orders
    orders = generate_orders(current_day, ORDERS_PER_DAY, suppliers, products, warehouses)
    with open(os.path.join(day_folder, 'purchase_orders.csv'), 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(['order_id','supplier_id','product_id','warehouse_id','order_date','quantity_ordered','unit_cost_eur','total_value_eur','status'])
        w.writerows(orders)

    # 3. Deliveries (based on today's orders that can be delivered)
    deliveries = generate_deliveries(current_day, DELIVERIES_PER_DAY, orders, suppliers, products, warehouses)
    with open(os.path.join(day_folder, 'deliveries.csv'), 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(['delivery_id','order_id','actual_delivery_date','quantity_delivered','quantity_accepted','quantity_rejected','delivery_status','carrier'])
        w.writerows(deliveries)

    # 4. Inventory (daily snapshot)
    inventory = generate_inventory(current_day, products, warehouses, prev_inventory)
    with open(os.path.join(day_folder, 'inventory.csv'), 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(['warehouse_id','product_id','quantity_on_hand'])
        w.writerows(inventory)
    prev_inventory = inventory

    print(f"Generated {day_folder}: {len(orders)} orders, {len(deliveries)} deliveries, {len(inventory)} inventory lines")

print("\nAll 4 daily snapshots created under 'supplyChain_db' folder.")
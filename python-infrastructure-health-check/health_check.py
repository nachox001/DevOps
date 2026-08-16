#!/usr/bin/env python3

import platform
import socket
import shutil
import json
import subprocess
from datetime import datetime


report = {
    "generated": str(datetime.now()),
    "hostname": socket.gethostname(),
    "operating_system": platform.platform(),
    "checks": {}
}


# Disk check
disk = shutil.disk_usage("/")

total_gb = round(disk.total / (1024 ** 3), 2)
free_gb = round(disk.free / (1024 ** 3), 2)
free_percent = round((disk.free / disk.total) * 100, 2)

disk_status = "WARNING" if free_percent < 10 else "OK"

report["checks"]["disk"] = {
    "total_gb": total_gb,
    "free_gb": free_gb,
    "free_percent": free_percent,
    "status": disk_status
}


# Memory check
with open("/proc/meminfo", "r") as file:
    memory_info = file.readlines()

memory_values = {}

for line in memory_info:
    key, value = line.split(":", 1)
    memory_values[key] = value.strip()

total_memory_kb = int(memory_values["MemTotal"].split()[0])
available_memory_kb = int(memory_values["MemAvailable"].split()[0])

total_memory_gb = round(total_memory_kb / 1024 / 1024, 2)
available_memory_gb = round(available_memory_kb / 1024 / 1024, 2)

memory_status = "WARNING" if available_memory_gb < 0.5 else "OK"

report["checks"]["memory"] = {
    "total_gb": total_memory_gb,
    "available_gb": available_memory_gb,
    "status": memory_status
}


# Service check
services = ["nginx", "ssh"]
service_results = {}

for service in services:
    result = subprocess.run(
        ["systemctl", "is-active", service],
        capture_output=True,
        text=True
    )

    if result.stdout.strip() == "active":
        service_results[service] = "OK"
    else:
        service_results[service] = "WARNING"

report["checks"]["services"] = service_results


# Connectivity check
try:
    connection = socket.create_connection(("8.8.8.8", 53), timeout=3)
    connection.close()
    connectivity_status = "OK"
except OSError:
    connectivity_status = "CRITICAL"

report["checks"]["connectivity"] = {
    "target": "8.8.8.8:53",
    "status": connectivity_status
}


# Write JSON report
with open("health-report.json", "w") as file:
    json.dump(report, file, indent=4)


print("Infrastructure health check completed.")
print("Report written to health-report.json")

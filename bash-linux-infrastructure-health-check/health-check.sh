#!/bin/bash

REPORT="./health-report.txt"

echo "LINUX INFRASTRUCTURE HEALTH CHECK" > "$REPORT"
echo "Generated: $(date)" >> "$REPORT"
echo "====================================" >> "$REPORT"

echo "" >> "$REPORT"
echo "HOSTNAME" >> "$REPORT"
hostname >> "$REPORT"

echo "" >> "$REPORT"
echo "OPERATING SYSTEM" >> "$REPORT"
grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"' >> "$REPORT"

echo "" >> "$REPORT"
echo "UPTIME" >> "$REPORT"
uptime -p >> "$REPORT"

echo "" >> "$REPORT"
echo "CPU LOAD" >> "$REPORT"
uptime >> "$REPORT"

echo "" >> "$REPORT"
echo "MEMORY" >> "$REPORT"
free -h >> "$REPORT"

echo "" >> "$REPORT"
echo "DISK" >> "$REPORT"

df -P -x tmpfs -x devtmpfs | tail -n +2 | while read filesystem blocks used available capacity mountpoint
do
    usage=${capacity%\%}

    echo "$mountpoint usage: $capacity" >> "$REPORT"

    if [ "$usage" -ge 90 ]; then
        echo "WARNING: $mountpoint is ${capacity} full" >> "$REPORT"
    fi
done

echo "" >> "$REPORT"
echo "NETWORK" >> "$REPORT"
ip -4 addr show | grep inet >> "$REPORT"

echo "" >> "$REPORT"
echo "IMPORTANT SERVICES" >> "$REPORT"

SERVICES=("nginx" "ssh")

for service in "${SERVICES[@]}"
do
    if systemctl is-active --quiet "$service"; then
        echo "$service : OK - Running" >> "$REPORT"
    else
        echo "$service : WARNING - Not Running" >> "$REPORT"
    fi
done

echo "" >> "$REPORT"
echo "CONNECTIVITY TEST" >> "$REPORT"

if ping -c 2 8.8.8.8 > /dev/null 2>&1; then
    echo "Connectivity: OK" >> "$REPORT"
else
    echo "Connectivity: CRITICAL - Ping failed" >> "$REPORT"
fi

echo "" >> "$REPORT"
echo "Health check completed." >> "$REPORT"

echo "Report generated at $REPORT"

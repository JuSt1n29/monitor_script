#!/bin/bash

TOKEN=""
CHAT_ID=""

DISK_THRESHOLD=90
RAM_THRESHOLD=90
CPU_THRESHOLD=90    
ZOMBIE_THRESHOLD=3  

HOSTNAME=$(hostname)

send_telegram() {
    local text="$1"
 
    local formatted_message="🖥️ [Host: $HOSTNAME] | $(date '+%Y-%m-%d %H:%M:%S')%0A$text"
    curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
        -d "chat_id=$CHAT_ID" \
        -d "text=$formatted_message" > /dev/null
}


DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    send_telegram "⚠️disk full $DISK_USAGE%!"
fi

RAM_USAGE=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
if [ "$RAM_USAGE" -gt "$RAM_THRESHOLD" ]; then
    send_telegram "⚠️RAM full : $RAM_USAGE%!"
fi

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' | cut -d. -f1)
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    send_telegram "CPU full  $CPU_USAGE%!"
fi

LOAD_AVG=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1 | sed 's/ //g')


SERVICES=("sshd" "docker" "nginx")

for SERVICE in "${SERVICES[@]}"; do
    if ! systemctl is-active --quiet "$SERVICE"; then
        send_telegram "🚨Service [$SERVICE] down "
    fi
done


ZOMBIE_COUNT=$(ps -eo state | grep -c "Z")
if [ "$ZOMBIE_COUNT" -gt "$ZOMBIE_THRESHOLD" ]; then
    send_telegram "Found zombie  $ZOMBIE_COUNT"
fi

TARGET_IP="8.8.8.8"
if ! ping -c 2 -W 3 "$TARGET_IP" > /dev/null 2>&1; then
    send_telegram "Network error  $TARGET_IP."
fi

UPTIME_INFO=$(uptime -p)
logger -t "SYS_MONITOR" "Status Check Completed. CPU: $CPU_USAGE%, RAM: $RAM_USAGE%, Disk: $DISK_USAGE%, LoadAvg: $LOAD_AVG, $UPTIME_INFO"

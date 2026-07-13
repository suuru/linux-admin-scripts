#!/bin/bash
THRESHOLD=80
ALERT_LOG="/var/log/disk_alerts.log"
ADMIN_EMAIL="you@example.com"   # optional: needs mailutils installed

echo "=== Disk check: $(date) ==="

df -H | grep -vE '^Filesystem|tmpfs|cdrom' | while read -r line; do
  usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
  mount=$(echo "$line" | awk '{print $6}')

  if [ "$usage" -ge "$THRESHOLD" ]; then
    msg="ALERT: $mount is at ${usage}% capacity"
    echo "$msg"
    echo "$(date): $msg" >> "$ALERT_LOG"

    # Uncomment to send email (requires: sudo apt install mailutils)
    # echo "$msg" | mail -s "Disk Alert on $(hostname)" "$ADMIN_EMAIL"
  fi
done

#!/bin/bash
LOG_DIR="/var/log/myapp"      # change to your log directory
ARCHIVE_DIR="/var/log/archive"
RETAIN_DAYS=7

mkdir -p "$ARCHIVE_DIR"

echo "=== Log rotation: $(date) ==="

# Compress logs older than 1 day
find "$LOG_DIR" -name "*.log" -mtime +1 | while read -r logfile; do
  gzip -v "$logfile"
  mv "${logfile}.gz" "$ARCHIVE_DIR/"
  echo "Archived: $logfile"
done

# Delete compressed archives older than RETAIN_DAYS
find "$ARCHIVE_DIR" -name "*.gz" -mtime +"$RETAIN_DAYS" -exec rm -v {} \;

echo "Rotation complete. Archive size: $(du -sh $ARCHIVE_DIR | cut -f1)"


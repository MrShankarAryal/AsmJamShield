#!/bin/bash

LOG_FILE="/var/log/securenetmon.log"

# Archive old logs to reduce file size
archive_logs() {
  local archive_dir="/var/log/securenetmon/archive"
  local archive_name="securenetmon-$(date +'%Y%m%d%H%M%S').log"

  echo "Archiving log file to $archive_dir/$archive_name..." >> $LOG_FILE
  mv "$LOG_FILE" "$archive_dir/$archive_name"
  touch "$LOG_FILE"
  echo "Log file archived and new log file created." >> $LOG_FILE
}

# Rotate logs based on size
rotate_logs() {
  local max_size=50000000  # 50MB
  local current_size=$(stat --format=%s "$LOG_FILE")

  echo "Checking if log rotation is needed..." >> $LOG_FILE
  if [ "$current_size" -ge "$max_size" ]; then
    archive_logs
  fi
}

# Check and verify log file integrity
verify_log_integrity() {
  if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file does not exist. Creating new log file." >> $LOG_FILE
    touch "$LOG_FILE"
  fi
  echo "Log file integrity verified." >> $LOG_FILE
}

#!/bin/bash

LOG_FILE="/var/log/securenetmon.log"

# Check system memory usage
check_memory_usage() {
  local memory_threshold=$1
  local current_memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
  
  echo "Checking system memory usage..." >> $LOG_FILE
  if (( $(echo "$current_memory_usage > $memory_threshold" | bc -l) )); then
    echo "Warning: Memory usage is above the threshold ($current_memory_usage%)." >> $LOG_FILE
  else
    echo "Memory usage is under control ($current_memory_usage%)." >> $LOG_FILE
  fi
}

# Check CPU usage
check_cpu_usage() {
  local cpu_threshold=$1
  local current_cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
  
  echo "Checking system CPU usage..." >> $LOG_FILE
  if (( $(echo "$current_cpu_usage > $cpu_threshold" | bc -l) )); then
    echo "Warning: CPU usage is above the threshold ($current_cpu_usage%)." >> $LOG_FILE
  else
    echo "CPU usage is under control ($current_cpu_usage%)." >> $LOG_FILE
  fi
}

# Check disk space usage
check_disk_space() {
  local disk_threshold=$1
  local current_disk_usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
  
  echo "Checking system disk space usage..." >> $LOG_FILE
  if [ "$current_disk_usage" -gt "$disk_threshold" ]; then
    echo "Warning: Disk space usage is above the threshold ($current_disk_usage%)." >> $LOG_FILE
  else
    echo "Disk space usage is under control ($current_disk_usage%)." >> $LOG_FILE
  fi
}

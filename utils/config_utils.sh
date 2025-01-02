#!/bin/bash

CONFIG_FILE="config/security.conf"
LOG_FILE="/var/log/securenetmon.log"

# Validate configuration file format
validate_config() {
  if ! grep -q '^interface=' "$CONFIG_FILE"; then
    echo "Error: Missing 'interface=' configuration. Please check your config." >> $LOG_FILE
    exit 1
  fi
  if ! grep -q '^encryption=' "$CONFIG_FILE"; then
    echo "Error: Missing 'encryption=' configuration. Please check your config." >> $LOG_FILE
    exit 1
  fi
  echo "Configuration file validated successfully." >> $LOG_FILE
}

# Update configuration parameter
update_config_param() {
  local param=$1
  local value=$2

  sed -i "s/^$param=.*/$param=$value/" "$CONFIG_FILE"
  if [ $? -eq 0 ]; then
    echo "Updated configuration: $param set to $value." >> $LOG_FILE
  else
    echo "Error: Failed to update $param." >> $LOG_FILE
    exit 1
  fi
}

#!/bin/bash

LOG_FILE="/var/log/securenetmon.log"

# Check if a specific network interface is up and running
check_interface_status() {
  local interface=$1

  if ip link show "$interface" | grep -q "state UP"; then
    echo "Network interface $interface is up." >> $LOG_FILE
  else
    echo "Error: Network interface $interface is down or not available." >> $LOG_FILE
    exit 1
  fi
}

# Get the IP address of a network interface
get_interface_ip() {
  local interface=$1

  IP_ADDRESS=$(ip addr show "$interface" | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
  if [ -z "$IP_ADDRESS" ]; then
    echo "Error: Failed to retrieve IP address for interface $interface." >> $LOG_FILE
    exit 1
  fi
  echo "IP address of $interface: $IP_ADDRESS" >> $LOG_FILE
}

# Network speed test (Ping a target IP)
test_network_speed() {
  local target_ip=$1
  local packets=10

  echo "Testing network speed to $target_ip..." >> $LOG_FILE
  ping -c $packets "$target_ip" > /dev/null
  if [ $? -eq 0 ]; then
    echo "Network speed test successful. Ping to $target_ip successful." >> $LOG_FILE
  else
    echo "Error: Network speed test failed. Unable to ping $target_ip." >> $LOG_FILE
    exit 1
  fi
}

# Disable network interface (for jamming or security)
disable_interface() {
  local interface=$1

  echo "Disabling network interface $interface for security purposes..." >> $LOG_FILE
  sudo ip link set "$interface" down
  if [ $? -eq 0 ]; then
    echo "Network interface $interface disabled successfully." >> $LOG_FILE
  else
    echo "Error: Failed to disable network interface $interface." >> $LOG_FILE
    exit 1
  fi
}

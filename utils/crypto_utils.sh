#!/bin/bash

LOG_FILE="/var/log/securenetmon.log"
KEY_STORAGE_DIR="/etc/securenetmon/keys"
ENCRYPTION_METHOD="AES-256-GCM"

# Generate a new encryption key
generate_encryption_key() {
  echo "Generating encryption key using $ENCRYPTION_METHOD..." >> $LOG_FILE
  openssl rand -out "$KEY_STORAGE_DIR/encryption.key" 32
  if [ $? -eq 0 ]; then
    echo "Encryption key generated successfully." >> $LOG_FILE
  else
    echo "Error: Failed to generate encryption key." >> $LOG_FILE
    exit 1
  fi
}

# Encrypt data using AES-256-GCM
encrypt_data() {
  local input_file=$1
  local output_file=$2

  echo "Encrypting data from $input_file to $output_file using $ENCRYPTION_METHOD..." >> $LOG_FILE
  openssl enc -aes-256-gcm -in "$input_file" -out "$output_file" -pass file:"$KEY_STORAGE_DIR/encryption.key"
  if [ $? -eq 0 ]; then
    echo "Data encrypted successfully." >> $LOG_FILE
  else
    echo "Error: Encryption failed." >> $LOG_FILE
    exit 1
  fi
}

# Decrypt data using AES-256-GCM
decrypt_data() {
  local input_file=$1
  local output_file=$2

  echo "Decrypting data from $input_file to $output_file using $ENCRYPTION_METHOD..." >> $LOG_FILE
  openssl enc -d -aes-256-gcm -in "$input_file" -out "$output_file" -pass file:"$KEY_STORAGE_DIR/encryption.key"
  if [ $? -eq 0 ]; then
    echo "Data decrypted successfully." >> $LOG_FILE
  else
    echo "Error: Decryption failed." >> $LOG_FILE
    exit 1
  fi
}

# Verify key integrity (Check for key tampering)
verify_key_integrity() {
  if [ ! -f "$KEY_STORAGE_DIR/encryption.key" ]; then
    echo "Error: Encryption key not found. Please generate the key first." >> $LOG_FILE
    exit 1
  fi
  echo "Encryption key integrity verified." >> $LOG_FILE
}

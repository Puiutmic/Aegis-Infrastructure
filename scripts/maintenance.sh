#!/bin/bash

# Aegis maintenance script
# Author: Puiutmic
# Description: Automated system updates and cleanup for low-resource environments

LOG_FILE="/var/log/aegis_maintenance.log"

echo "--- Maintenance started at $(date) ---" >> $LOG_FILE

# System updates
echo "[INFO] Updating system packages..." >> $LOG_FILE
sudo apt-get update && sudo apt-get upgrade -y >> $LOG_FILE 2>&1

# Docker cleanup 
echo "[INFO] Pruning Docker system..." >> $LOG_FILE
sudo docker system prune -f >> $LOG_FILE 2>&1

# Simple check to ensure logs don't consume all disk space
LOG_SIZE=$(du -k $LOG_FILE | cut -f1)
if [ $LOG_SIZE -gt 5000 ]; then
    echo "[INFO] Log file too large. Rotating..." >> $LOG_FILE
    mv $LOG_FILE "$LOG_FILE.old"
    touch $LOG_FILE
fi

echo "--- Maintenance completed at $(date) ---" >> $LOG_FILE

#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$BASE_DIR/logs/ssh_monitor.log"

mkdir -p "$BASE_DIR/logs"

echo "==================================" | tee -a "$LOG_FILE"
echo "		SSH SECURITY MONITOR" | tee -a "$LOG_FILE"
echo "		$(date)" | tee -a "$LOG_FILE"
echo "==================================" | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "[1] Failed SSH passwords" | tee -a "$LOG_FILE"

sudo grep 'Failed password' /var/log/auth.log 2>/dev/null | tail -50 | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "[2] Invalid SSH users" | tee -a "$LOG_FILE"

sudo grep 'Invalid user' /var/log/auth.log 2>/dev/null | tail -50 | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "[3] Successful SSH logins" | tee -a "$LOG_FILE"

sudo grep 'sshd.*Accepted' /var/log/auth.log 2>/dev/null | tail -50 | tee -a "$LOG_FILE"

echo "" |tee -a "$LOG_FILE"
echo "[4] Failed login count" | tee -a "$LOG_FILE"

COUNT=$(sudo grep -c 'Failed password' /var/log/auth.log 2>/dev/null)

echo "Failed SSH attempts recorded: $COUNT" | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "[5] Top source IP addresses" | tee -a "$LOG_FILE"

sudo grep 'Failed password' /var/log/auth.log 2>/dev/null | awk '{print $(NF-3)}' | sort | uniq -c | head -20 | tee -a "$LOG_FILE"

echo ""
echo "SSH investigation completed."
echo "Log: $LOG_FILE"
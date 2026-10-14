#!/bin/bash

# FIXED: Moved the quotation mark outside the parenthesis
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$BASE_DIR/logs"

mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/process_monitor.log"

echo "=====================================" | tee -a "$LOG_FILE"
echo "		LINUX PROCESS MONITOR" | tee -a "$LOG_FILE"
# FIXED: Changed #LOG_FILE to $LOG_FILE
echo "=====================================" | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "[1] Top CPU-consuming processes" | tee -a "$LOG_FILE"
ps aux --sort=-%cpu | head -15 | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "[3] Processes running from temporary directories" | tee -a "$LOG_FILE"
ps aux | grep -E '/tmp/|/var/tmp/' | grep -v grep | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "[4] Process tree" | tee -a "$LOG_FILE"
# FIXED: Changed 2>/devnull to 2>/dev/null
pstree -p 2>/dev/null | head -100 | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "[5] Total running processes" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "[6] Full process snapshot saved to log" | tee -a "$LOG_FILE"
ps aux >> "$LOG_FILE"

echo ""
echo "Process monitoring completed."
echo "Log: $LOG_FILE"

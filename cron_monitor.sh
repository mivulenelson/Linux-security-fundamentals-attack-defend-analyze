#!/bin/bash

BASE_DIR="$(dc "$(dirname "$0")" && pwd)"
LOG_FILE="$BASE_DIR/logs/cron_monitor.log"

mkdir -p "$BASE_DIR/logs"
 
echo "==================================="
echo "		CRON JOB MONITOR" | tee -a "$LOG_FILE"
echo "		$(date)" | tee -a "$LOG_FILE"
echo "===================================" | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "[1] Current user's crontab" | tee -a "$LOG_FILE"

crontab -l 2>&1 | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "[2] Root crontab" | tee -a "$LOG_FILE"

sudo crontab -l 2>&1 | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "[3] /etc/crontab" | tee -a "$LOG_FILE"

sudo cat /etc/crontab 2>/dev/null | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "[4] Cron directories" | tee -a "$LOG_FILE"

for DIR in /etc/cron.d /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly
do
	echo "-- $DIR ---" | tee -a "$LOG_FILE"
	sudo ls -lah "$DIR" 2>/dev/null | tee -a "LOG_FILE"
done

echo "" | tee -a "$LOG_FILE"
echo "[5] Suspicious command patterns in cron files" | tee -a "$LOG_FILE"

sudo grep -RniE 'curl|wget|nc|ncat|bash|python|perl|php' /etc/cron* /var/spool/cron 2>/dev/null | tee -a "$LOG_FILE"

echo ""
echo "Cron investigation completed."
echo "Log: $LOG_FILE"
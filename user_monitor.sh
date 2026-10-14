#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
BASELINE="$BASE_DIR/baselines/users.txt"
LOG_FILE="$BASE_DIR/logs/user_monitor.log"

mkdir -p "$BASE_DIR/baselines" "$BASE_DIR/logs"

echo "==================================="
echo "		LINUS USER MONITOR"
echo "		$(date)"
echo "==================================="

echo ""
echo "[1] All users"
# FIXED: Path changed to /etc/passwd
cut -d: -f1 /etc/passwd | tee "$LOG_FILE"

echo ""
echo "[2] UID 0 accounts"
# FIXED: Added closing curly brace } and changed path to /etc/passwd
awk -F: '$3 == 0 {print $1}' /etc/passwd

echo ""
echo "[3] Users with interactive shells"
# FIXED: Path changed to /etc/passwd
grep -E '/bin/bash|/bin/sh|/bin/zsh' /etc/passwd

echo ""
echo "[4] Members of sudo group"
getent group sudo

echo ""
echo "[5] Current logged-in users"
who 

echo ""
echo "[6] Curent sessions"
w

echo ""
echo "[7] User baseline"
# FIXED: Path changed to /etc/passwd
cut -d: -f1 /etc/passwd > /tmp/current_users.txt

if [ ! -f "$BASELINE" ]; then
	cp /tmp/current_users.txt "$BASELINE"
	echo "User baseline created."
else
	echo "Changes from baseline:"
	diff -u "$BASELINE" /tmp/current_users.txt
fi

rm -f /tmp/current_users.txt

echo ""
echo "User investigation compeleted."
echo "Log: $LOG_FILE"

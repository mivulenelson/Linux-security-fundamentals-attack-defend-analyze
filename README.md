Linux SOC Laboratory - Monitoring Scripts Reference

Welcome to the monitoring script documentation for the Linux SOC Laboratory. This guide details the purpose and functionality of each automated Bash monitoring script used to collect telemetry, establish baselines, and detect anomalies across the endpoint.

1. User Account Monitor (user_monitor.sh)

Overview

The user_monitor.sh script audits system account configurations, identifies privilege structures, tracks active sessions, and compares current user lists against a pre-established baseline to spot unauthorized user creation.   

Key Checks Performed
- All System Accounts: Extracts and dumps every user entry from /etc/passwd.   
- Privileged Accounts (UID 0): Filters for accounts assigned UID 0, identifying any unauthorized secondary root accounts.   
- Interactive Shells: Searches for users configured with operational shells (/bin/bash, /bin/sh, /bin/zsh).   
- Sudo Group Membership: Queries system group databases (getent group sudo) to verify administrative membership.   
- Active Sessions: Captures currently logged-in users and session statistics via who and w.   
- Baseline Divergence: Generates a dynamic user snapshot, compares it against stored baselines (baselines/users.txt), and highlights additions or deletions using diff -u.   

2. SSH Security Monitor (ssh_monitor.sh)

Overview

The ssh_monitor.sh script parses authentication logs to track brute-force attacks, invalid username attempts, successful remote logins, and source IP frequencies targeting the Secure Shell daemon.   

Key Checks Performed
- Failed Passwords: Extracts the last 50 failed authentication attempts from /var/log/auth.log.   
- Invalid Users: Identifies connection attempts targeting non-existent user accounts.   
- Successful Logins: Filters for sshd successful acceptance strings (sshd.*Accepted).   
- Failure Metrics: Quantifies total failed SSH attempts using counter logic (grep -c).   
- Source IP Frequency Analysis: Parses failed auth logs to isolate attacker IP addresses, sorting and counting occurrences to highlight top offending sources (awk, sort, uniq).   

3. Process Monitor (process_monitor.sh)

Overview

The process_monitor.sh script investigates running system processes, isolates high-resource consumption, detects execution from unauthorized temporary directories, and maps process lineage.   

Key Checks Performed
- CPU Consumption: Ranks and logs the top 15 CPU-consuming processes using ps aux --sort=-%cpu.   
- Temporary Directory Execution: Hunts for processes running out of volatile or shared directories (/tmp/, /var/tmp/), which are common staging grounds for malware.   
- Process Tree Mapping: Visualizes parent-child process relationships using pstree -p.   
- Process Snapshots: Records total process counts and dumps a full process snapshot into the investigation logs (logs/process_monitor.log).   

4. Cron Job Monitor (cron_monitor.sh)

Overview

The cron_monitor.sh script audits scheduled tasks across user crontabs, system-wide configuration files, and standard cron directories to detect persistence mechanisms.   
Key Checks Performed
- User & Root Crontabs: Dumps active scheduled tasks for standard users and root via crontab -l.   
- System Cron Files: Inspects /etc/crontab and lists file contents across routine scheduling directories (/etc/cron.d, cron.hourly, daily, weekly, monthly).   
- Suspicious Command Pattern Matching: Recursively scans cron directories and spool paths using regular expressions to flag dangerous utilities commonly used in reverse shells or payloads (such as curl, wget, nc, ncat, python, perl, php).   

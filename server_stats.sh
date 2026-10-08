#!/usr/bin/env bas#!/usr/bin/env bash
set -euo pipefail

cpu_usage=$(vmstat 5 2 | tail -1 | awk '{print 100 - $15}')

mem_total=$(free -m | awk 'NR==2{print $2}')
mem_used=$(free -m | awk 'NR==2{print $3}')
mem_avail=$(free -m | awk 'NR==2{print $7}')
mem_used_pct=$(( mem_used * 100 / mem_total ))
mem_avail_pct=$(( mem_avail * 100 / mem_total ))

disk_total=$(df -m / | awk 'NR==2{print $2}')
disk_used=$(df -m / | awk 'NR==2{print $3}')
disk_avail=$(df -m / | awk 'NR==2{print $4}')
disk_pct=$(df -m / | awk 'NR==2{print $5}')

top_cpu=$(top -b -n 2 -d 1 -o %CPU | grep -A 5 'PID' | tail -n 6)
top_mem=$(top -b -n 2 -d 1 -o %MEM | grep -A 5 'PID' | tail -n 6)

echo "==================================================================="
echo "                Server Performance Stats Checker"
echo "==================================================================="
echo
echo "CPU Usage:    ${cpu_usage}%"
echo "Memory:       Used ${mem_used}MB (${mem_used_pct}%) | Available ${mem_avail}MB (${mem_avail_pct}%) | Total ${mem_total}MB"
echo "Disk (/):     Used ${disk_used}MB (${disk_pct}) | Free ${disk_avail}MB | Total ${disk_total}MB"
echo
echo "Top 5 processes by CPU:"
echo "${top_cpu}"
echo
echo "Top 5 processes by memory:"
echo "${top_mem}"

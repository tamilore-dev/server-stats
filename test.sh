#!/bin/bash


# Total CPU usage 
echo "Total Cpu(s) Usage (%): "
top -bn1 | grep "%Cpu(s):" | awk '{print "Total Usage: " 100 - $8 "%" "\tUser processes: " $2 "%" "\tSystem Usage: " $4 "%" "\tIdle Cpu: " $8 "%" }'

# Total memory usage (Free vs Used including percentage)
echo -e "\nTotal Memory Usage: "
free -h | awk 'NR==2 {print "Total Memory: " ($2) "\t Used: " $3 " (" ($3 / $2 * 100) "%) \tFree: " $7 " (" ($7/$2*100) "%)" }'

# Total disk usage (Free vs Used including percentage)
echo -e "\nTotal disk usage: "
df -h --total | awk '/total/ {print "Total: " $2 "\tUsed: " $3 " (" $5 ")" "\tFree: " $4 " (" ($4/$2 * 100) "%)"}'

# Top 5 processes by CPU usage
echo -e "\nTop 5 processes by CPU usage: "
top -bn1 -o %CPU | grep PID -A 5

# Top 5 processes by memory usage
echo -e "\nTop 5 processes by Memory usage: "
top -bn1 -o %MEM | grep PID -A 5

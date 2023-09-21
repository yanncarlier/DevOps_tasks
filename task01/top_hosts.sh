#!/bin/bash

# Replace 'access.log' with the actual path to your log file
logfile="access.log"

start_date="09/Jul/2019:00:00:00"
end_date="19/Jul/2019:23:59:59"

# Use awk to filter log entries within the date range and count requests per host
requests=$(awk -v start="$start_date" -v end="$end_date" '$4 >= "["start"]" && $4 <= "["end"]" {print $1}' "$logfile" | sort | uniq -c | sort -nr)

# Display the top 10 hosts with the most requests
echo "Top 10 Hosts with the Most Requests:"
echo "$requests" | head -n 10

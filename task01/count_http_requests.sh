#!/bin/bash

# Replace 'access.log' with the actual path to your log file
logfile="access.log"

# Use grep to filter lines containing "HTTP/1.1" (assuming all HTTP requests are in this format)
http_requests=$(grep "HTTP/1.1" "$logfile" | wc -l)

echo "Total HTTP requests recorded in $logfile: $http_requests"

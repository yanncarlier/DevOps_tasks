#!/bin/bash

# you need to install geoiplookup command, on my OS, Ubuntu:
# sudo apt install geoip-bin


# Replace 'access.log' with the actual path to your log file
logfile="access.log"

# Create an associative array to store counts for each country
declare -A country_counts

# Function to extract the country from an IP address
get_country() {
    local ip="$1"
    local country
    # Use geoiplookup to get the country for the IP
    country=$(geoiplookup "$ip" | awk -F ": " '{print $2}')
    echo "$country"
}

# Loop through the log file and count requests by country
while read -r line; do
    # Extract the IP address from the log entry (assuming it's in the 1st field)
    ip=$(echo "$line" | awk '{print $1}')
    
    # Get the country for the IP addresss
    country=$(get_country "$ip")
    
    # Increment the count for the country in the associative array
    if [ -n "$country" ]; then
        ((country_counts["$country"]++))
    fi
done < "$logfile"

# Find the country with the most requests
most_requests_country=""
most_requests_count=0

for country in "${!country_counts[@]}"; do
    count=${country_counts["$country"]}
    if ((count > most_requests_count)); then
        most_requests_country="$country"
        most_requests_count="$count"
    fi
done

# Print the country with the most requests
echo "Country with the most requests: $most_requests_country ($most_requests_count requests)"

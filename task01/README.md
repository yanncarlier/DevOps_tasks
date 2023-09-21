# Task 1 - Access log analytics

 

## To count the total number of HTTP requests recorded in the access logfile:

We can use grep and the  wc command in a bash script to count the total number of HTTP requests recorded in an access logfile. 

Here's how the script works:

It defines the logfile variable, which should contain the path to your access logfile. You should replace "access.log" with the actual path to your log file.
It uses the grep command to search for lines in the log file that contain "HTTP/1.1". This assumes that all HTTP requests are logged in this format. Adjust the pattern to match the format of your log entries if necessary.
The grep output is piped to wc -l, which counts the number of lines matching the pattern.
Finally, it prints the total count of HTTP requests to the console.
Make sure to save the script in a file (e.g., count_http_requests.sh), give it executable permissions using chmod +x count_http_requests.sh, and then run it with ./count_http_requests.sh in the same directory as your log file.

## Find the country that made the most requests

To find the country that made the most requests based on the source IP addresses in your log file. To achieve this, we can use the geoiplookup command to determine the country associated with each IP address. 

we need to install geoiplookup command, on my OS, Ubuntu:
$ sudo apt install geoip-bin

Here's how the script works:

It defines the logfile variable, which should contain the path to your access logfile. Replace "access.log" with the actual path.
It creates an associative array country_counts to store the counts of requests for each country.
The get_country function takes an IP address as input and uses geoiplookup to determine the associated country. It then returns the country name.
The script reads each line of the log file and extracts the source IP address. It uses the get_country function to get the country for each IP address and increments the count in the country_counts array.
Finally, it finds the country with the most requests by iterating through the associative array and prints the result.
Make sure to save the script in a file (e.g., find_most_requests_country.sh), give it executable permissions using chmod +x find_most_requests_country.sh, and then run it with ./find_most_requests_country.sh in the same directory as your log file.

## To find the Top 10 hosts that made the most requests from 2019-06-10 00:00:00 up to and including 2019-06-19 23:59:59

To find the top 10 hosts that made the most requests from June 10, 2019, 00:00:00 to June 19, 2019, 23:59:59 in a Bash script, we can use awk and sort. 

Here's how the script works:

It defines the logfile variable with the path to your access logfile. Replace "access.log" with the actual path.
It defines the start_date and end_date variables to specify the date range you want to analyze.
It uses awk to filter log entries within the specified date range using the $4 field (assuming the date is in the fourth field of each log entry). It then extracts the host (IP address) from each entry.
The sort and uniq -c commands are used to count the number of requests for each host.
Finally, it uses sort -nr to sort the hosts in descending order by the number of requests and displays the top 10 hosts.
Make sure to save the script in a file (e.g., top_hosts.sh), give it executable permissions using chmod +x top_hosts.sh, and then run it with ./top_hosts.sh in the same directory as your log file. 
#!/bin/bash

# Set default values if not specified
protocol=${1:-tcp}
state=${2:-ESTABLISHED}

# Check if protocol is valid
if [[ "$protocol" != "tcp" && "$protocol" != "udp" ]]; then
    echo "Invalid protocol specified. Please use 'tcp' or 'udp'."
    exit 1
fi

# Check if state is valid
if ! grep -q "$state" <(netstat -an); then
    echo "Invalid state specified. Please use a valid netstat state."
    exit 1
fi

# Parse output of netstat command and extract remote IP addresses
netstat_output=$(netstat -an | grep "$state" | grep "$protocol")
remote_ips=$(echo "$netstat_output" | awk '{print $5}' | cut -d ':' -f 1 | sort | uniq)

# Set threshold for long-running connections (in seconds)
threshold=3600

# Initialize status variables
status=0
output=""

# Iterate over each remote IP address and count the number of established connections
for ip in $remote_ips; do
    # Filter output to show only connections to this IP address
    ip_output=$(echo "$netstat_output" | grep "^.* $ip:")

    # Iterate over each connection and check if it has been running for a long time
    while read -r line; do
        start_time=$(echo "$line" | awk '{print $NF}')
        duration=$(($(date +%s) - $(date -d "$start_time" +%s)))
        if [[ "$duration" -gt "$threshold" ]]; then
            status=2
            output+="$line has been running for $duration seconds (threshold: $threshold)\n"
        fi
    done <<< "$ip_output"
    
    # Count number of established connections to this IP address
    count=$(echo "$ip_output" | wc -l)
    output+="$ip: $count established $protocol connections in $state state\n"
done

# Output results in Nagios format
if [[ "$status" -eq 0 ]]; then
    echo "OK: No long-running connections detected | connections=0"
else
    echo "CRITICAL: Long-running connections detected | connections=1"
fi
echo -e "$output"

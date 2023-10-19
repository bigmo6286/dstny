#!/bin/bash

# Read the live subdomains
subs=$(cat live.txt)

# Create directories to store the results
mkdir -p results/{ip,server,tech}

# Loop through the subdomains
for sub in $subs
do
    # Perform IP probing
    echo $sub | naabu -silent > results/ip/$sub-ip.txt

    # Perform service detection
    echo $sub | naabu -silent -p 80,443 > results/server/$sub-server.txt

    # Perform technology detection
    echo $sub | naabu -silent -p 80,443 -n -o results/tech/$sub-tech.txt
done

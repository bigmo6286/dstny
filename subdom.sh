#!/bin/bash

# Read domains and IP addresses from files
domains=$(cat domains.txt)
ips=$(cat ip.txt)

# Create a directory to store the results
mkdir results

# Loop through the domains
for domain in $domains
do
    # Perform subdomain enumeration with Amass
    amass enum -passive -d $domain > results/$domain-amass.txt

    # Perform subdomain enumeration with SubBrute
    subbrute.py $domain > results/$domain-subbrute.txt
done

# Loop through the IP addresses
for ip in $ips
do
    # Perform reverse DNS lookup
    host $ip > results/$ip-reverse-dns.txt
done

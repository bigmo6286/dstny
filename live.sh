#!/bin/bash

# Read the subdomains from the files
amass=$(cat results/*-amass.txt | awk '{print $1}' | sort -u)
subbrute=$(cat results/*-subbrute.txt | sort -u)

# Combine the subdomains
echo "$amass\n$subbrute" | tr '[:upper:]' '[:lower:]' | sort -u > allsubs.txt

# Check for live subdomains
cat allsubs.txt | httprobe > live.txt
done

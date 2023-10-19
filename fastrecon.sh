#!/bin/bash

# Check if tools are installed, if not, install them
if ! command -v subfinder &> /dev/null
then
    echo "subfinder could not be found, installing..."
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
fi

if ! command -v assetfinder &> /dev/null
then
    echo "assetfinder could not be found, installing..."
    go install github.com/tomnomnom/assetfinder@latest
fi

if ! command -v amass &> /dev/null
then
    echo "amass could not be found, installing..."
    sudo apt install amass
fi

if ! command -v findomain &> /dev/null
then
    echo "findomain could not be found, installing..."
    wget https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux -O findomain
    chmod +x findomain
fi

if ! command -v knockpy &> /dev/null
then
    echo "knockpy could not be found, installing..."
    git clone https://github.com/guelfoweb/knock.git
    cd knock
    sudo python3 setup.py install
    cd ..
    sudo rm -r knock
fi

if ! command -v shuffledns &> /dev/null
then
    echo "shuffledns could not be found, installing..."
    go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
fi

if ! command -v httpx &> /dev/null
then
    echo "httpx could not be found, installing..."
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest
fi

if ! command -v waybackurls &> /dev/null
then
    echo "waybackurls could not be found, installing..."
    go install github.com/tomnomnom/waybackurls@latest
fi

# Subdomain enumeration
subfinder -d $(cat domains.txt) -o subs1.txt
assetfinder --subs-only $(cat domains.txt) | tee -a subs1.txt
amass enum -d $(cat domains.txt) | tee -a subs1.txt
findomain -t $(cat domains.txt) -q  | tee -a subs1.txt
knockpy $(cat domains.txt) | tee -a subs1.txt
shuffledns -d $(cat domains.txt) -w /usr/share/seclists/Discovery/DNS/deepmagic.com-prefixes-top50000.txt -r /usr/share/seclists/Discovery/DNS/deepmagic.com-suffixes-top50000.txt | tee -a subs1.txt
cat subs1.txt | sort -u | tee -a subs.txt

# Find live domains
cat subs.txt | httpx -o alive.txt
cat alive.txt | waybackurls > wayback_output.txt

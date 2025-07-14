#!/usr/bin/python3
import re

def extract_slverr_addresses(log_file):
    slverr_addresses = []

    
    pattern = re.compile(r'ADDR=0x[0-9A-Fa-f]+.*SLVERR=1')


    addr_pattern = re.compile(r'Addr:([0-9A-Fa-f]+)')

    with open(log_file, 'r') as f:
        for line in f:
           if 'slverr:1' in line:
                match = addr_pattern.search(line)
                if match:
                    slverr_addresses.append(match.group(0))

    return slverr_addresses


if __name__ == "__main__":
    log_path = "APB/log/logfile.log"  # Replace with your actual log filename
    addresses = extract_slverr_addresses(log_path)

    if addresses:
        print("Addresses where SLVERR was asserted:")
        count
        for addr in addresses:
            print(addr)
            count=count+1
        print("total wrong addresses:",count)
    else:
        print("No SLVERR assertions found in the log.")


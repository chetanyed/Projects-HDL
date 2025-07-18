#!/usr/bin/python3
# to find transactions of given addresses
import re
addr=input("enter address:")
addr_match=f'addr:{addr}'

def extract_addr(log_file):
      addr_details=[]


      pattern_split=re.compile(r'\W+')

      with open(log_file, 'r') as f:
          for line in f:
              if "reset" not in line:
                  match=re.search(addr_match,line,re.IGNORECASE)

                  if match:
                       addr_details.append(line)

                    
      return addr_details


if __name__=="__main__":
       log_path = "/Users/chetanya/scripts/logfile.log" //logfile path
       details=extract_addr(log_path)
       if details:
           for item in details:
                      print(item)
       else:
           print("no transaction occures")

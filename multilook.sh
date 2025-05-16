#!/bin/bash

# Step 1: Create the list of RSLC files
ls RSLC -1 > listarslc.txt

# Step 2: Loop through each line in the list
while read -r rslc_file; do
  # Extract the date from the filename (assumes the format includes the date as YYYYMMDD)
  date=$(echo "$rslc_file" | grep -oE '[0-9]{8}')
  
  # If a valid date is extracted, run multilookRSLC with the necessary arguments
  if [[ $date =~ ^[0-9]{8}$ ]]; then
    multilookRSLC "$date" 7 2 1
  else
    echo "Skipping file: $rslc_file (Invalid date format)"
  fi
done < listarslc.txt

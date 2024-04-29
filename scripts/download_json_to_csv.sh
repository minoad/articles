#!/usr/bin/env bash

url="$1"
# Download IBM finance data in JSON format
wget -O data.json "$url"

# Check if download was successful
if [ $? -ne 0 ]; then
    echo "Failed to download IBM finance data."
    exit 1
fi

# Convert JSON to CSV using Python and pandas
python3 -c "
import pandas as pd
df = pd.read_json('data.json')
df.to_csv('../data/data.csv', index=False)
"

# Check if conversion was successful
if [ $? -eq 0 ]; then
    echo "Conversion to CSV successful. CSV file: ../data/data.csv"
else
    echo "Failed to convert JSON to CSV."
fi
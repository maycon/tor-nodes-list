#!/bin/bash

# Download data from Onionoo
curl -s "https://onionoo.torproject.org/details?search=type:relay%20running:true" -o tor-data.json

# Process data and extract exit nodes and guard nodes
cat tor-data.json | jq -r '
  .relays[] | 
  select(.running == true) |
  {
    fingerprint: .fingerprint,
    nickname: .nickname,
    address: .or_addresses[0],
    flags: .flags,
    country: .country,
    is_exit: ([.flags[] | select(. == "Exit")] | length > 0),
    is_guard: ([.flags[] | select(. == "Guard")] | length > 0)
  }
' > all-nodes.json

# Extract exit nodes
cat all-nodes.json | jq -s '[.[] | select(.is_exit == true)]' > exit-nodes.json

# Extract guard nodes
cat all-nodes.json | jq -s '[.[] | select(.is_guard == true)]' > guard-nodes.json

# Create plain text versions (IPs only)
cat exit-nodes.json | jq -r '.[].address' | cut -d: -f1 | sort -u > exit-nodes.txt
cat guard-nodes.json | jq -r '.[].address' | cut -d: -f1 | sort -u > guard-nodes.txt

# Generate statistics
EXIT_COUNT=$(cat exit-nodes.json | jq 'length')
GUARD_COUNT=$(cat guard-nodes.json | jq 'length')
TOTAL_COUNT=$(cat all-nodes.json | jq -s 'length')
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")

# Create statistics file
echo "Tor Nodes Statistics" > stats.txt
echo "Last Update: $TIMESTAMP" >> stats.txt
echo "" >> stats.txt
echo "Total Running Relays: $TOTAL_COUNT" >> stats.txt
echo "Exit Nodes: $EXIT_COUNT" >> stats.txt
echo "Guard Nodes: $GUARD_COUNT" >> stats.txt

cat stats.txt

# Remove temporary files
rm tor-data.json all-nodes.json

echo ""
echo "✅ Files generated successfully!"
echo "   - exit-nodes.json"
echo "   - exit-nodes.txt"
echo "   - guard-nodes.json"
echo "   - guard-nodes.txt"
echo "   - stats.txt"
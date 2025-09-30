# Tor Nodes List

[![Update Tor Nodes List](https://github.com/maycon/tor-nodes-list/actions/workflows/tor-nodes.yml/badge.svg)](https://github.com/maycon/tor-nodes-list/actions/workflows/tor-nodes.yml)

Automated hourly updates of Tor network exit nodes and guard nodes lists. This repository fetches real-time data from the official Tor Project API and generates both JSON and plain text formats for easy integration.

## 📊 What's Inside

This repository automatically maintains up-to-date lists of:
- **Exit Nodes** - Relays that allow traffic to exit the Tor network
- **Guard Nodes** - Entry relays that serve as the first hop in Tor circuits

## 🤖 How It Works

A GitHub Actions workflow runs **every hour** (at minute 0) and:

1. 📥 Fetches live relay data from [Onionoo API](https://onionoo.torproject.org/)
2. 🔍 Filters for running relays with Exit and Guard flags
3. 📝 Generates multiple output formats (JSON + plain text)
4. 📊 Compiles network statistics
5. 💾 Commits changes automatically if data has updated

## 📁 Generated Files

| File | Description | Format |
|------|-------------|--------|
| `exit-nodes.json` | Complete exit nodes with metadata | JSON |
| `exit-nodes.txt` | Exit node IP addresses only | Plain text |
| `guard-nodes.json` | Complete guard nodes with metadata | JSON |
| `guard-nodes.txt` | Guard node IP addresses only | Plain text |
| `stats.txt` | Network statistics summary | Plain text |

### JSON Structure

Each node entry includes:
```json
{
  "fingerprint": "ABCD1234...",
  "nickname": "NodeNickname",
  "address": "1.2.3.4:9001",
  "flags": ["Exit", "Fast", "Guard", "Running", "Stable", "Valid"],
  "country": "us",
  "is_exit": true,
  "is_guard": false
}
```

## 🚀 Quick Start

### Using the Lists

```bash
# Clone the repository
git clone https://github.com/maycon/tor-nodes-list.git
cd tor-nodes-list

# View statistics
cat stats.txt

# View exit node IPs
cat exit-nodes.txt

# View guard nodes with full details
cat guard-nodes.json | jq '.[0:5]'  # First 5 entries

# Count nodes
wc -l exit-nodes.txt
wc -l guard-nodes.txt
```

### Direct Download (without cloning)

```bash
# Download exit nodes list
curl -O https://raw.githubusercontent.com/maycon/tor-nodes-list/main/exit-nodes.txt

# Download with wget
wget https://raw.githubusercontent.com/maycon/tor-nodes-list/main/guard-nodes.json
```


## 📂 Repository Structure

```
tor-nodes-list/
├── .github/
│   └── workflows/
│       └── tor-nodes.yml        # Hourly update workflow
├── .gitignore                   # Ignore temp files
├── README.md                    # This file
├── test-locally.sh              # Local testing script
├── exit-nodes.json              # ⚙️ Auto-generated
├── exit-nodes.txt               # ⚙️ Auto-generated
├── guard-nodes.json             # ⚙️ Auto-generated
├── guard-nodes.txt              # ⚙️ Auto-generated
└── stats.txt                    # ⚙️ Auto-generated
```

## 🔧 Use Cases

### Block Tor Exit Nodes (Firewall/WAF)

```bash
# Generate iptables rules
while read ip; do
  echo "iptables -A INPUT -s $ip -j DROP"
done < exit-nodes.txt
```

### Threat Intelligence Integration

```python
import json

with open('exit-nodes.json', 'r') as f:
    nodes = json.load(f)

exit_ips = [node['address'].split(':')[0] for node in nodes]
print(f"Loaded {len(exit_ips)} Tor exit IPs")
```

### Log Analysis

```bash
# Check if IP is in exit nodes list
grep "1.2.3.4" exit-nodes.txt && echo "Tor exit node detected"
```

## 📊 Data Source

- **Provider**: The Tor Project
- **API**: Onionoo Protocol
- **Endpoint**: `https://onionoo.torproject.org/details?search=type:relay%20running:true`
- **Documentation**: https://metrics.torproject.org/onionoo.html
- **Update Frequency**: Onionoo data updates hourly
- **License**: Tor Project data (public domain)

## ⚙️ Workflow Schedule

The workflow runs:
- ⏰ **Automatically**: Every hour at minute 0 (`0 * * * *`)
- 🖱️ **Manually**: Via Actions tab → "Run workflow"

## 📈 Statistics Example

```
Tor Nodes Statistics
Last Update: 2025-09-30 14:23:45 UTC

Total Running Relays: 8450
Exit Nodes: 1234
Guard Nodes: 2567
```

## 🤝 Contributing

Contributions are welcome! Feel free to:
- 🐛 Report bugs
- 💡 Suggest features
- 🔧 Submit pull requests

## ⚖️ Legal Notice

This tool is for security research, network analysis, and educational purposes. Always comply with local laws and the terms of service of any systems you interact with.

## 📜 License

This project is released into the **public domain**. The Tor relay data is provided by The Tor Project and is in the public domain.

---

## 🔗 Useful Links

- [Tor Metrics](https://metrics.torproject.org/)
- [Onionoo API Documentation](https://metrics.torproject.org/onionoo.html)
- [Tor Project](https://www.torproject.org/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

**Last Updated**: 2025-09-30  
**Maintainer**: [@maycon](https://github.com/maycon)
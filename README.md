# WiFi Credential Exfiltration Toolkit

<div align="center">
  
![Python](https://img.shields.io/badge/python-3.7%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Windows%20%7C%20macOS-lightgrey)

**An offensive security toolkit for WiFi credential extraction and penetration testing**

  <img src="https://i.ibb.co/sv4bbwPY/wifirecon1.png" alt="WiFi Recon Toolkit">

</div>

## ⚠️ Security Research Warning

> **This tool is for authorized security testing and educational purposes only.** Unauthorized access to computer systems and networks is illegal. Users must comply with all applicable laws and obtain proper authorization before testing any systems.

## 📋 Overview

This toolkit implements advanced techniques for WiFi credential extraction during penetration testing engagements. It serves as an offensive security platform to understand:
- How to extract saved WiFi passwords from compromised systems
- Methods for covert data exfiltration using legitimate protocols
- Evasion techniques to bypass modern security controls
- Advanced persistence and stealth methodologies

## 🏗️ Architecture

```
wifi-exfil-tool/
├── server.py              # Flask receiver server
├── launch.sh             # Main orchestration script
├── cleanup.sh            # Process and file cleanup utility
├── templates/            # Platform-specific payload templates
│   ├── windows.ps1.tpl   # Windows PowerShell extraction template
│   ├── linux.sh.tpl      # Linux NetworkManager extraction template
│   └── macos.sh.tpl     # macOS Keychain extraction template
├── payloads/             # Generated attack payloads (created at runtime)
├── captures/             # Collected credentials (created at runtime)
└── cloudflared/          # Cloudflare tunnel binary (downloaded at runtime)
```

## 🚀 Quick Start

### Prerequisites

```bash
# Install required dependencies
sudo apt update
sudo apt install python3 python3-pip curl openssl python3-flask

# Alternative: Install Flask via pip if system package unavailable
# pip3 install flask --user
```

### Basic Usage

```bash
# Clone and navigate to project
git clone <repository-url>
cd wifi-exfil-tool

# Make scripts executable
chmod +x launch.sh cleanup.sh

# Run the toolkit
./launch.sh
```

## 🛠️ Core Components

### Server (`server.py`)
- Flask-based HTTP receiver listening on `localhost:8080`
- Token-authenticated upload endpoint `/upload`
- Real-time credential display in terminal
- Automatic file storage with IP-timestamp naming

### Launcher (`launch.sh`)
Interactive setup script featuring:
- Animated terminal interface with branding
- Cross-platform payload generation (Windows/Linux/macOS)
- **Enhanced directory management**: Creates dedicated `payloads/`, `captures/`, and `cloudflared/` directories within tool directory
- Cloudflare tunnel establishment for external connectivity
- Real-time capture monitoring
- **Robust cleanup procedures**: Comprehensive process termination and resource cleanup
- Detailed status reporting for all operations

### Templates
**Windows Template (`windows.ps1.tpl`)**:
- Uses `netsh wlan` commands to enumerate WiFi profiles
- Extracts SSID names, authentication types, and clear-text passwords
- Implements retry logic and self-destruction mechanisms

**Linux Template (`linux.sh.tpl`)**:
- Leverages `nmcli` NetworkManager for credential extraction
- Targets 802.11 wireless connections specifically
- Fixed to avoid duplicate SSID/PSK output
- Includes operational security measures (history clearing)

**macOS Template (`macos.sh.tpl`)**:
- Uses `security find-generic-password` for Keychain access
- Extracts current WiFi network and all saved passwords
- Leverages `airport` command for network info
- Uses `plutil` to read saved network preferences
- Includes self-destruction and history clearing

## 🔧 Technical Details

### Communication Flow
1. **Initialization**: Server starts with randomly generated authentication token
2. **Tunneling**: Cloudflare tunnel establishes encrypted external access
3. **Payload Deployment**: Target-specific scripts generated with embedded credentials
4. **Extraction**: Victim systems execute payloads to harvest WiFi credentials
5. **Transmission**: Data sent via authenticated POST requests through tunnel
6. **Collection**: Server receives and displays credentials in real-time

### Advanced Capabilities Demonstrated
- **Token Authentication**: Secure communication channel for data exfiltration
- **Encrypted Tunneling**: Cloudflare TLS encryption for covert communications
- **Advanced Evasion**: Anti-forensic techniques including self-deletion and artifact cleanup
- **Resilient Transmission**: Smart retry logic with exponential backoff for reliability
- **Process Hardening**: Isolated execution environments for operational security

## 🔍 Offensive Intelligence Gathering

### Adversary Tactics and Techniques

**Network Indicators of Compromise:**
- Outbound connections to `*.trycloudflare.com` infrastructure
- POST requests to `/upload` endpoints with `X-Token` headers
- Unusual DNS queries for Cloudflare domains during reconnaissance

**Host-Based Artifacts:**
- PowerShell execution of `netsh wlan show profiles` for network enumeration
- `nmcli` commands targeting wireless connection details
- Suspicious file creation/deletion patterns in TEMP directories
- Command history manipulation and cleanup activities

**Operational Behaviors:**
- Rapid enumeration of saved network profiles
- Covert data staging and transmission to external infrastructure
- Self-modifying executables and anti-forensic measures

### Blue Team Countermeasures

1. **Endpoint Protection**: Monitor for unauthorized PowerShell/bash script execution
2. **Network Monitoring**: Detect anomalous Cloudflare tunnel traffic patterns
3. **Access Controls**: Restrict WiFi profile enumeration capabilities system-wide
4. **User Awareness**: Train personnel to recognize social engineering attempts
5. **Credential Hygiene**: Implement regular password rotation and certificate-based authentication

## 🧪 Testing Environment

For safe testing and research:

```bash
# Setup isolated test environment
mkdir test-environment
cd test-environment

# Create test WiFi profiles (Linux example)
sudo nmcli con add type wifi con-name "TestNetwork" \
    ifname wlan0 ssid "TestNetwork" \
    wifi-sec.key-mgmt wpa-psk \
    wifi-sec.psk "testpassword123"

# Run toolkit in controlled environment
../wifi-exfil-tool/launch.sh
```

## 📊 Logging and Monitoring

Captured credentials are stored in the `captures/` directory with format:
```
captures/
└── 192.168.1.100_20240125-143022.txt
```

Each file contains:
- Timestamp of capture
- Source IP address
- Extracted WiFi profile information
- Authentication and cipher details

## 🧹 Enhanced Cleanup Procedures

The toolkit now features comprehensive cleanup mechanisms:

```bash
# Standard cleanup (stops processes, clears logs)
./cleanup.sh

# Full cleanup (removes all generated files including cloudflared)
./cleanup.sh --full

# Help documentation
./cleanup.sh --help
```

**Enhanced cleanup features:**
- Automatic process termination for Flask server and Cloudflared tunnel
- Background process detection and cleanup
- Temporary file removal (/tmp/cfd.log)
- Graceful shutdown with forced cleanup for stubborn processes
- Real-time status reporting during cleanup operations

## 📚 Educational Resources

### Related Research Topics
- Living-off-the-land techniques (LotL)
- Command and Control (C2) communication methods
- Endpoint detection and response (EDR) evasion
- Network protocol abuse for data exfiltration

### Defensive Tooling
- Sysmon configuration for PowerShell monitoring
- Network intrusion detection signatures
- Host-based behavioral analytics
- Cloud access security broker (CASB) integration

## ⚖️ Legal Compliance

This tool must only be used in accordance with:
- Company policies and acceptable use guidelines
- Applicable federal, state, and local laws
- Written authorization from system owners
- Ethical hacking frameworks and standards

## 🤝 Contributing

This project welcomes contributions focused on:
- Improving defensive detection capabilities
- Enhancing security research documentation
- Developing better mitigation strategies
- Creating educational content for cybersecurity professionals

## 📄 License

This research tool is provided for educational and defensive security purposes under the MIT License.

---

<div align="center">

**Developed for Defensive Security Research**  
*Understanding threats to better protect systems*

</div>

# Unattended Computer Pranks

> **Advanced Persistent Threat (APT) Simulation Suite for Security Awareness Training**

A cross-platform collection of realistic cyber attack simulation tools designed to demonstrate the importance of physical security and the risks of leaving workstations unattended. This suite provides hands-on security awareness training through simulated multi-stage attacks that mimic real-world APT behavior.

## ⚠️ Important Disclaimer

**FOR AUTHORIZED SECURITY AWARENESS TRAINING AND EDUCATIONAL PURPOSES ONLY**

This software is designed exclusively for:
- Authorized security awareness training programs
- Educational demonstrations in controlled environments
- Internal security testing with proper authorization
- CTF (Capture The Flag) competitions and exercises

**NEVER use these tools:**
- Without explicit written consent from system owners
- On systems you don't own or have authorization to test
- In production environments without proper approval
- For malicious purposes or unauthorized access

Misuse of these tools may violate local, state, or federal laws. Users are solely responsible for compliance with all applicable laws and regulations.

## Features

- **Multi-Stage Attack Simulation**: Realistic 8-phase APT kill chain from initial access to total compromise
- **Cross-Platform Support**: Native implementations for Windows, macOS, and Linux
- **Configurable Intensity Levels**: Three preset intensity modes (Mild, Moderate, Hollywood)
- **13+ Attack Modules**: Diverse module types including ransomware, data exfiltration, keyloggers, and browser attacks
- **Built-in Killswitch**: Emergency termination mechanism for immediate shutdown
- **Educational Value**: Demonstrates real attack techniques in a safe, controlled manner
- **No Actual Harm**: All simulations are visual/audio only - no actual system modifications occur
- **Module Lifecycle Management**: Automatic cleanup to prevent resource exhaustion

## Platform Support

| Platform | Script | Requirements | Terminal Emulator |
|----------|--------|--------------|-------------------|
| **Windows** | `winprank.ps1` | PowerShell 5.1+ | Windows Terminal, PowerShell, CMD |
| **macOS** | `osxprank.sh` | Bash 4.0+, macOS 10.12+ | Terminal.app, iTerm2 |
| **Linux** | `linuxprank.sh` | Bash 4.0+ | gnome-terminal, xterm, konsole, xfce4-terminal |

## Installation

### Windows

1. Clone or download this repository:
```powershell
git clone https://github.com/drakeaxelrod/unattended-computer-pranks.git
cd unattended-computer-pranks
```

2. Ensure PowerShell execution policy allows script execution:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### macOS

1. Clone or download this repository:
```bash
git clone https://github.com/drakeaxelrod/unattended-computer-pranks.git
cd unattended-computer-pranks
```

2. Make the script executable:
```bash
chmod +x osxprank.sh
```

3. (Optional) Install text-to-speech for audio warnings:
```bash
# say command is pre-installed on macOS
```

### Linux

1. Clone or download this repository:
```bash
git clone https://github.com/drakeaxelrod/unattended-computer-pranks.git
cd unattended-computer-pranks
```

2. Make the script executable:
```bash
chmod +x linuxprank.sh
```

3. (Optional) Install dependencies for full feature support:
```bash
# Debian/Ubuntu
sudo apt-get install beep espeak xdg-utils

# Fedora/RHEL
sudo dnf install beep espeak xdg-utils

# Arch Linux
sudo pacman -S beep espeak xdg-utils
```

## Usage

### Windows

```powershell
# Run with default settings (Moderate intensity)
.\winprank.ps1

# Run with specific intensity level
.\winprank.ps1 -Intensity Mild
.\winprank.ps1 -Intensity Hollywood

# Run in demo mode (educational popups enabled)
.\winprank.ps1 -Mode Demo
```

### macOS

```bash
# Run with default settings (Moderate intensity)
./osxprank.sh

# Run with specific intensity level
./osxprank.sh Launcher 0 Mild
./osxprank.sh Launcher 0 Hollywood
```

### Linux

```bash
# Run with default settings (Moderate intensity)
./linuxprank.sh

# Run with specific intensity level
./linuxprank.sh Launcher 0 Mild
./linuxprank.sh Launcher 0 Hollywood
```

### Intensity Levels

| Level | Description | Spawn Delay | Max Windows | Behavior |
|-------|-------------|-------------|-------------|----------|
| **Mild** | Gentle demonstration | 8 seconds | 8 windows | Slow, educational pace |
| **Moderate** | Realistic simulation | 3 seconds | 15 windows | Balanced intensity |
| **Hollywood** | Maximum chaos | 1 second | 25 windows | Aggressive, overwhelming |

## Killswitch

**IMPORTANT**: To stop the simulation at any time, type the word `secret` in any active window. This is the ONLY way to terminate the simulation once it begins.

- Typing `secret` activates the emergency killswitch
- All modules will terminate gracefully
- The training reveal message will display
- All spawned processes will clean up automatically

## Attack Phases

The simulation progresses through 8 distinct attack phases that mirror real APT tactics:

1. **Initial Access** - Simulated breach and foothold establishment
2. **Execution** - Malware deployment and code execution
3. **Privilege Escalation** - Elevation to higher permission levels
4. **Credential Harvesting** - Capture of authentication credentials
5. **Lateral Movement** - Spread across network infrastructure
6. **Persistence** - Establishing long-term access mechanisms
7. **Data Exfiltration** - Extraction of sensitive information
8. **Total Compromise** - Ransomware deployment and final impact

## Modules

### Core Modules (All Platforms)

| Module | Description | Lifecycle | Visual Impact |
|--------|-------------|-----------|---------------|
| **Matrix** | Cascading random characters | Short (3 min) | Green terminal rain effect |
| **Hex** | Memory dump simulation | Short (3 min) | Continuous hex output |
| **Infection** | Malware injection simulation | Medium (7 min) | System file modification alerts |
| **Glitch** | Screen corruption effects | Short (3 min) | Random glitch artifacts |
| **Map** | Network reconnaissance | Short (3 min) | IP scanning and port enumeration |
| **Keylogger** | Credential capture simulation | Medium (7 min) | Fake credential harvesting |
| **LateralMovement** | Network propagation | Medium (7 min) | Multi-system compromise attempts |
| **Ransomware** | File encryption simulation | Long (until killswitch) | Encryption countdown and warnings |
| **DataExfil** | Data theft simulation | Long (until killswitch) | Upload progress to C2 servers |
| **Chat** | Threat actor communications | Long (until killswitch) | Simulated hacker chat logs |

### Browser Modules (Platform-Specific)

| Module | Description | Platform Notes |
|--------|-------------|----------------|
| **BrowserCascade** | Rapid tab spawning | Opens 10 browser windows with warnings |
| **PhishingSimulator** | Fake login page | Creates temporary HTML phishing page |
| **CryptoMiner** | Mining simulation | Displays fake cryptocurrency mining activity |

## Module Lifecycle

Modules automatically manage their lifecycle to prevent resource exhaustion:

- **Short-Lived** (180 seconds): Matrix, Hex, Glitch, Map
- **Medium-Lived** (420 seconds): Infection, Keylogger, LateralMovement
- **Long-Lived** (until killswitch): Ransomware, DataExfil, Chat, Browser modules

Short and medium-lived modules will automatically terminate after their duration, while long-lived modules persist until the killswitch is activated.

## How It Works

### Windows (PowerShell)

- Uses `Start-Process` with CMD to spawn detached terminal windows
- Leverages Windows API via C# interop for window manipulation
- Console beeps via `[console]::beep()` for audio effects
- File-based flags in `$env:TEMP` for inter-process communication

### macOS (Bash)

- Uses `osascript` to control Terminal.app windows
- `say` command for text-to-speech warnings
- `open` command for browser integration
- File-based flags in `/tmp` for killswitch mechanism

### Linux (Bash)

- Auto-detects available terminal emulator (gnome-terminal, xterm, konsole, etc.)
- `beep` or `espeak` for audio warnings
- `xdg-open` for browser integration
- Process management via bash job control

## Educational Value

This suite demonstrates several critical security concepts:

1. **Physical Security Importance**: Shows how quickly an unattended system can be compromised
2. **APT Tactics**: Illustrates realistic multi-stage attack progression
3. **Defense Awareness**: Highlights the importance of:
   - Screen locking when leaving workstations
   - Endpoint protection and monitoring
   - Network segmentation
   - Incident response procedures
   - Zero-trust security models

## Safety Features

- **No Actual System Modifications**: All output is visual/audio only
- **Emergency Killswitch**: Type `secret` for immediate termination
- **Resource Management**: Automatic module lifecycle prevents unlimited spawning
- **Temporary Files Only**: All artifacts stored in system temp directories
- **Clean Shutdown**: Automatic cleanup of all spawned processes and flag files
- **Training Reveal**: Clear educational message shown upon termination

## Best Practices for Security Trainers

1. **Obtain Written Consent**: Always get explicit authorization before running
2. **Brief Participants**: Explain the killswitch (`secret`) before starting
3. **Controlled Environment**: Run on isolated test systems, not production
4. **Debrief After**: Discuss what happened and security lessons learned
5. **Document Sessions**: Keep records of training activities for compliance
6. **Monitor Resources**: Watch system resources during Hollywood intensity mode
7. **Test First**: Run at Mild intensity first to familiarize yourself

## Troubleshooting

### Windows

**Issue**: "Execution policy does not allow script"
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Issue**: Script triggers killswitch immediately
- Old flag files may exist from previous runs
- The script now auto-cleans these on startup
- Manually remove: `Remove-Item $env:TEMP\cyber*.tmp -Force`

### macOS

**Issue**: "Permission denied"
```bash
chmod +x osxprank.sh
```

**Issue**: Terminal windows don't spawn
- Ensure Terminal.app has accessibility permissions
- Check System Preferences → Security & Privacy → Privacy → Automation

### Linux

**Issue**: "No supported terminal emulator found"
```bash
# Install a supported terminal emulator
sudo apt-get install gnome-terminal  # Debian/Ubuntu
sudo dnf install gnome-terminal      # Fedora/RHEL
```

**Issue**: No sound effects
```bash
# Install beep or espeak
sudo apt-get install beep espeak  # Debian/Ubuntu
```

## Contributing

Contributions are welcome! Please follow these guidelines:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/new-module`)
3. **Test** thoroughly on target platform
4. **Commit** with clear messages (`git commit -m 'Add new module: SessionStealer'`)
5. **Push** to your branch (`git push origin feature/new-module`)
6. **Submit** a pull request

### Ideas for Contributions

- New attack modules (session hijacking, DNS tunneling, etc.)
- Additional sound effects and visual improvements
- Platform-specific optimizations
- Improved phase transitions
- Better educational messaging
- Multi-language support
- Configuration file support

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by real-world APT tactics and techniques
- Based on the MITRE ATT&CK framework
- Created for security education and awareness training
- Thanks to the cybersecurity community for continuous threat intelligence

## Author

**Drake Axelrod**
- GitHub: [@drakeaxelrod](https://github.com/drakeaxelrod)
- Repository: [unattended-computer-pranks](https://github.com/drakeaxelrod/unattended-computer-pranks)

## Support

If you find this tool useful for security training, please:
- Star the repository
- Share with security awareness trainers
- Report bugs and suggest improvements via GitHub Issues
- Contribute new modules or platform support

---

**Remember**: This tool is for educational purposes only. Always obtain proper authorization before use. The best defense against physical security threats is a locked screen and security awareness.

**Lock Your Screen. Every Time. No Exceptions.**

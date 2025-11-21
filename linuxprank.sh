#!/bin/bash
################################################################################
# Linux Advanced Persistent Threat Simulation
# Security Awareness Training Tool - Linux Version
#
# WARNING: This script is designed for authorized security awareness training
# and educational purposes only. Requires explicit consent before execution.
################################################################################

set -e

# ============================================================================
# Global Configuration
# ============================================================================

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
TEMP_DIR="${TMPDIR:-/tmp}"
FLAG_FILE="${TEMP_DIR}/cyberApocalypseFlag.tmp"
PAUSE_FLAG="${TEMP_DIR}/cyberpauseflag.tmp"
MODULE_TRACKER="${TEMP_DIR}/activeModules.tmp"
INPUT_BUFFER=""

# Parse command line arguments
MODULE="${1:-Launcher}"
GENERATION="${2:-0}"
INTENSITY="${3:-Moderate}"
MODE="${4:-Demo}"

# Clean up flag files on launcher/master start
if [[ "$MODULE" == "Launcher" ]] || [[ "$MODULE" == "Master" ]]; then
    rm -f "$FLAG_FILE" "$PAUSE_FLAG" "$MODULE_TRACKER" 2>/dev/null
fi

# Create temp directory if it doesn't exist
mkdir -p "$TEMP_DIR"

# Detect available terminal emulator
TERMINAL=""
if command -v gnome-terminal &>/dev/null; then
    TERMINAL="gnome-terminal"
elif command -v xterm &>/dev/null; then
    TERMINAL="xterm"
elif command -v konsole &>/dev/null; then
    TERMINAL="konsole"
elif command -v xfce4-terminal &>/dev/null; then
    TERMINAL="xfce4-terminal"
elif command -v mate-terminal &>/dev/null; then
    TERMINAL="mate-terminal"
else
    echo "ERROR: No supported terminal emulator found!"
    echo "Please install: gnome-terminal, xterm, konsole, xfce4-terminal, or mate-terminal"
    exit 1
fi

# Configuration based on intensity
case "$INTENSITY" in
    "Mild")
        SPAWN_DELAY=8
        TYPE_SPEED=35
        MAX_MODULES=8
        MAX_ACTIVE_WINDOWS=8
        RESPAWN_CHANCE=10
        WINDOW_MOVEMENT_FREQ=30
        ;;
    "Moderate")
        SPAWN_DELAY=3
        TYPE_SPEED=20
        MAX_MODULES=12
        MAX_ACTIVE_WINDOWS=15
        RESPAWN_CHANCE=30
        WINDOW_MOVEMENT_FREQ=15
        ;;
    "Hollywood")
        SPAWN_DELAY=1
        TYPE_SPEED=10
        MAX_MODULES=16
        MAX_ACTIVE_WINDOWS=25
        RESPAWN_CHANCE=50
        WINDOW_MOVEMENT_FREQ=8
        ;;
esac

# Module lifecycle durations (in seconds)
LIFETIME_SHORT=180    # 3 minutes (Matrix, Hex, Glitch, Map)
LIFETIME_MEDIUM=420   # 7 minutes (Infection, Keylogger, LateralMovement)
LIFETIME_LONG=999999  # Until killswitch (Ransomware, DataExfil, Chat, Master, Browser)

# Available modules
MODULES=(
    "Matrix"
    "Hex"
    "Infection"
    "Glitch"
    "Map"
    "Keylogger"
    "LateralMovement"
    "Ransomware"
    "DataExfil"
    "Chat"
    "BrowserCascade"
    "PhishingSimulator"
    "CryptoMiner"
)

# Attack phase definitions
PHASE_NAMES=(
    "Initial Access"
    "Execution"
    "Privilege Escalation"
    "Credential Harvesting"
    "Lateral Movement"
    "Persistence"
    "Data Exfiltration"
    "Total Compromise"
)

# ============================================================================
# Helper Functions
# ============================================================================

function should_stop() {
    [[ -f "$FLAG_FILE" ]]
}

function should_pause() {
    while [[ -f "$PAUSE_FLAG" ]] && ! should_stop; do
        sleep 1
    done
}

function should_exit_module() {
    local max_duration=$1
    local start_time=$2
    local elapsed=$(($(date +%s) - start_time))

    [[ $elapsed -ge $max_duration ]] || should_stop
}

function play_sound() {
    local sound_type=$1

    # Try different methods for playing beeps
    if command -v beep &>/dev/null; then
        case "$sound_type" in
            "warning")
                beep -f 800 -l 200 &
                ;;
            "critical")
                beep -f 1000 -l 300 -r 3 &
                ;;
            "alert")
                beep -f 600 -l 150 &
                ;;
            "intrusion")
                beep -f 900 -l 100 -r 5 &
                ;;
            "success")
                beep -f 700 -l 200 &
                ;;
        esac
    elif command -v paplay &>/dev/null && [[ -f /usr/share/sounds/freedesktop/stereo/bell.oga ]]; then
        paplay /usr/share/sounds/freedesktop/stereo/bell.oga &>/dev/null &
    else
        # Fallback to console beep
        printf '\a'
    fi
}

function speak() {
    local message=$1

    # Try different text-to-speech engines
    if command -v espeak &>/dev/null; then
        espeak "$message" 2>/dev/null &
    elif command -v spd-say &>/dev/null; then
        spd-say "$message" 2>/dev/null &
    elif command -v festival &>/dev/null; then
        echo "$message" | festival --tts 2>/dev/null &
    fi
}

function random_between() {
    local min=$1
    local max=$2
    echo $((min + RANDOM % (max - min + 1)))
}

function spawn_module() {
    local module_name=$1
    local gen=$((GENERATION + 1))

    # Check if we should spawn based on max windows
    if [[ -f "$MODULE_TRACKER" ]]; then
        local active_count=$(wc -l < "$MODULE_TRACKER" 2>/dev/null || echo 0)
        if [[ $active_count -ge $MAX_ACTIVE_WINDOWS ]]; then
            return
        fi
    fi

    # Track this module
    echo "$$:$module_name:$(date +%s)" >> "$MODULE_TRACKER"

    # Spawn new terminal window with module
    case "$TERMINAL" in
        "gnome-terminal")
            gnome-terminal --title="${module_name}_NODE_$RANDOM" -- bash -c "cd '$TEMP_DIR' && bash '$SCRIPT_PATH' '$module_name' '$gen' '$INTENSITY' '$MODE'; exec bash" &>/dev/null &
            ;;
        "xterm")
            xterm -T "${module_name}_NODE_$RANDOM" -e "bash -c \"cd '$TEMP_DIR' && bash '$SCRIPT_PATH' '$module_name' '$gen' '$INTENSITY' '$MODE'; exec bash\"" &>/dev/null &
            ;;
        "konsole")
            konsole --new-tab -p tabtitle="${module_name}_NODE_$RANDOM" -e bash -c "cd '$TEMP_DIR' && bash '$SCRIPT_PATH' '$module_name' '$gen' '$INTENSITY' '$MODE'; exec bash" &>/dev/null &
            ;;
        "xfce4-terminal")
            xfce4-terminal --title="${module_name}_NODE_$RANDOM" -e "bash -c \"cd '$TEMP_DIR' && bash '$SCRIPT_PATH' '$module_name' '$gen' '$INTENSITY' '$MODE'; exec bash\"" &>/dev/null &
            ;;
        "mate-terminal")
            mate-terminal --title="${module_name}_NODE_$RANDOM" -e "bash -c \"cd '$TEMP_DIR' && bash '$SCRIPT_PATH' '$module_name' '$gen' '$INTENSITY' '$MODE'; exec bash\"" &>/dev/null &
            ;;
    esac
}

function type_effect() {
    local text=$1
    local speed=${2:-$TYPE_SPEED}

    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep "0.0${speed}"
        should_pause
        if should_stop; then break; fi
    done
    echo
}

function random_ip() {
    echo "$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
}

function random_mac() {
    printf "%02X:%02X:%02X:%02X:%02X:%02X" $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256))
}

function random_hash() {
    local length=${1:-64}
    tr -dc 'a-f0-9' < /dev/urandom | head -c "$length"
}

# ============================================================================
# Module Implementations
# ============================================================================

function run_matrix() {
    clear
    echo "Starting Matrix visualization..."

    local start_time=$(date +%s)
    local chars='!@#$%^&*()_+-=[]{}|;:,.<>?/~`'

    while ! should_exit_module "$LIFETIME_SHORT" "$start_time"; do
        should_pause

        local line=""
        for ((i=0; i<80; i++)); do
            if ((RANDOM % 5 == 0)); then
                line+="${chars:$((RANDOM % ${#chars})):1}"
            else
                line+=" "
            fi
        done
        echo -e "\033[32m$line\033[0m"
        sleep 0.05
    done

    exit 0
}

function run_hex() {
    clear
    echo "Loading hex dump..."

    local start_time=$(date +%s)
    local offset=0

    while ! should_exit_module "$LIFETIME_SHORT" "$start_time"; do
        should_pause

        printf "%08x: " $offset
        for ((i=0; i<16; i++)); do
            printf "%02x " $((RANDOM % 256))
        done
        echo

        offset=$((offset + 16))
        sleep 0.1
    done

    exit 0
}

function run_infection() {
    clear
    echo -e "\033[31m[!] MALWARE DETECTED - INITIATING INFECTION SEQUENCE\033[0m"
    play_sound "critical"

    local start_time=$(date +%s)
    local files=("libc.so.6" "libpthread.so.0" "libdl.so.2" "libm.so.6" "ld-linux.so.2" "libssl.so")

    while ! should_exit_module "$LIFETIME_MEDIUM" "$start_time"; do
        should_pause

        local file="${files[$((RANDOM % ${#files[@]}))]}"
        local action=("Injecting" "Hooking" "Patching" "Modifying")
        local status=("SUCCESS" "ACTIVE" "INFECTED")

        echo -e "\033[33m[$(date +%T)] ${action[$((RANDOM % ${#action[@]}))]} /lib/x86_64-linux-gnu/$file... ${status[$((RANDOM % ${#status[@]}))]} \033[0m"
        sleep $(random_between 1 3)

        if ((RANDOM % 10 == 0)); then
            play_sound "alert"
            echo -e "\033[31m[!] Process injection detected in PID $((1000 + RANDOM % 9000))\033[0m"
        fi
    done

    exit 0
}

function run_glitch() {
    local start_time=$(date +%s)

    while ! should_exit_module "$LIFETIME_SHORT" "$start_time"; do
        should_pause
        clear

        # Random glitch effects
        for ((i=0; i<20; i++)); do
            local random_text=$(tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c $((10 + RANDOM % 50)))
            echo -e "\033[3$((RANDOM % 8))m$random_text\033[0m"
        done

        sleep 0.5
    done

    exit 0
}

function run_map() {
    clear
    echo "Network mapping in progress..."

    local start_time=$(date +%s)

    while ! should_exit_module "$LIFETIME_SHORT" "$start_time"; do
        should_pause

        local ip=$(random_ip)
        local mac=$(random_mac)
        local ports=$((RANDOM % 65535))
        local status=("ACTIVE" "VULNERABLE" "COMPROMISED" "SCANNING")

        echo "[$(date +%T)] $ip ($mac) - Open ports: $ports - ${status[$((RANDOM % ${#status[@]}))]}"
        sleep $(random_between 1 2)
    done

    exit 0
}

function run_keylogger() {
    clear
    echo -e "\033[36m[*] Keylogger active - Capturing credentials...\033[0m"

    local start_time=$(date +%s)
    local usernames=("admin" "root" "user" "sysadmin" "john.doe" "jane.smith")
    local hosts=("webserver" "database" "fileserver" "mailserver")

    while ! should_exit_module "$LIFETIME_MEDIUM" "$start_time"; do
        should_pause

        local user="${usernames[$((RANDOM % ${#usernames[@]}))]}"
        local host="${hosts[$((RANDOM % ${#hosts[@]}))]}"
        local pass=$(tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c 12)

        echo "[$(date +%T)] Captured: $user@$host : $pass"
        sleep $(random_between 3 8)

        if ((RANDOM % 5 == 0)); then
            play_sound "success"
            echo -e "\033[32m[+] High-value credential detected!\033[0m"
        fi
    done

    exit 0
}

function run_lateral_movement() {
    clear
    echo -e "\033[35m[*] Lateral movement in progress...\033[0m"

    local start_time=$(date +%s)
    local hostnames=("web01" "db01" "app01" "file01" "mail01" "proxy01")

    while ! should_exit_module "$LIFETIME_MEDIUM" "$start_time"; do
        should_pause

        local target="${hostnames[$((RANDOM % ${#hostnames[@]}))]}"
        local target_ip=$(random_ip)
        local methods=("SSH" "SMB" "NFS" "RDP" "VNC" "rsync")
        local method="${methods[$((RANDOM % ${#methods[@]}))]}"

        echo "[$(date +%T)] Attempting $method to $target ($target_ip)..."
        sleep 2
        echo -e "\033[32m[+] Connection established - Deploying payload\033[0m"
        play_sound "success"
        sleep $(random_between 2 5)
    done

    exit 0
}

function run_ransomware() {
    clear
    echo -e "\033[31m"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║          YOUR FILES HAVE BEEN ENCRYPTED                      ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "\033[0m"

    play_sound "critical"
    speak "Warning. Ransomware encryption detected."

    local extensions=(".doc" ".xls" ".pdf" ".jpg" ".png" ".sql" ".db" ".zip" ".tar.gz")
    local paths=("Documents" "Desktop" "Downloads" "Pictures" "Videos" "Music" "Projects")
    local encrypted=0

    while ! should_stop; do
        should_pause

        local path="${paths[$((RANDOM % ${#paths[@]}))]}"
        local ext="${extensions[$((RANDOM % ${#extensions[@]}))]}"
        local filename=$(tr -dc 'a-z' < /dev/urandom | head -c 8)

        echo "[ENCRYPTING] /home/$USER/$path/$filename$ext"
        encrypted=$((encrypted + 1))

        if ((encrypted % 50 == 0)); then
            echo -e "\033[33m[!] $encrypted files encrypted\033[0m"
            play_sound "warning"
        fi

        sleep 0.1
    done

    exit 0
}

function run_data_exfil() {
    clear
    echo -e "\033[36m[*] Data exfiltration in progress...\033[0m"
    play_sound "alert"

    local c2_servers=("185.220.101.$(random_between 1 254)" "194.165.16.$(random_between 1 254)")
    local filetypes=("credentials.db" "emails.mbox" "financial_data.xlsx" "customer_info.csv" "source_code.tar.gz")

    while ! should_stop; do
        should_pause

        local server="${c2_servers[$((RANDOM % ${#c2_servers[@]}))]}"
        local file="${filetypes[$((RANDOM % ${#filetypes[@]}))]}"
        local size=$((RANDOM % 500 + 10))

        echo "[$(date +%T)] Uploading $file (${size}MB) to C2: $server:443"

        # Simulate upload progress
        for ((i=0; i<=100; i+=20)); do
            should_pause
            if should_stop; then break; fi
            echo "  Progress: [$i%] $(($size * $i / 100))MB transferred"
            sleep 1
        done

        echo -e "\033[32m[+] Upload complete\033[0m"
        play_sound "success"
        sleep $(random_between 5 10)
    done

    exit 0
}

function run_chat() {
    clear
    echo -e "\033[35m╔════════════════════════════════════════════════╗\033[0m"
    echo -e "\033[35m║     THREAT ACTOR COMMUNICATION CHANNEL         ║\033[0m"
    echo -e "\033[35m╚════════════════════════════════════════════════╝\033[0m"
    echo

    local actors=("shadow_broker" "night_raven" "phantom_0x" "dark_spider" "ghost_net")

    local messages=(
        "Initial access confirmed. Moving to phase 2."
        "Root credentials obtained."
        "Persistence established on 15 machines."
        "Database server compromised. Exfiltrating now."
        "Firewall rules updated. Backdoor active."
        "Backup systems located and encrypted."
        "C2 connection stable. Awaiting further instructions."
        "Payment received. Releasing partial decryption keys."
        "Security team is onto us. Accelerating timeline."
        "All objectives complete. Initiating final stage."
    )

    while ! should_stop; do
        should_pause

        local actor="${actors[$((RANDOM % ${#actors[@]}))]}"
        local msg="${messages[$((RANDOM % ${#messages[@]}))]}"

        echo -e "\033[36m[$(date +%T)] <$actor>\033[0m $msg"
        sleep $(random_between 8 15)

        if ((RANDOM % 5 == 0)); then
            play_sound "alert"
        fi
    done

    exit 0
}

function run_browser_cascade() {
    clear
    echo -e "\033[33m[*] Browser attack vector initiated\033[0m"

    local urls=(
        "about:blank"
        "data:text/html,<h1>SYSTEM COMPROMISED</h1>"
        "data:text/html,<body bgcolor=red><h1>ERROR: SECURITY BREACH</h1></body>"
    )

    local count=0
    while ! should_stop && [[ $count -lt 10 ]]; do
        should_pause

        local url="${urls[$((RANDOM % ${#urls[@]}))]}"

        # Try different browsers
        if command -v firefox &>/dev/null; then
            firefox --new-window "$url" &>/dev/null &
        elif command -v chromium &>/dev/null; then
            chromium --new-window "$url" &>/dev/null &
        elif command -v google-chrome &>/dev/null; then
            google-chrome --new-window "$url" &>/dev/null &
        elif command -v xdg-open &>/dev/null; then
            xdg-open "$url" &>/dev/null &
        fi

        count=$((count + 1))
        echo "[$(date +%T)] Browser window $count spawned"
        sleep $(random_between 2 5)

        play_sound "alert"
    done

    exit 0
}

function run_phishing_simulator() {
    clear
    echo -e "\033[33m[*] Generating phishing page...\033[0m"

    # Create fake login page
    local phish_file="${TEMP_DIR}/microsoft_login_$RANDOM.html"
    cat > "$phish_file" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Microsoft Account Sign In</title>
    <style>
        body { font-family: 'Segoe UI', Arial; background: #f3f3f3; }
        .container { max-width: 400px; margin: 100px auto; background: white; padding: 40px; box-shadow: 0 2px 6px rgba(0,0,0,0.2); }
        input { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #8c8c8c; }
        button { width: 100%; padding: 12px; background: #0067b8; color: white; border: none; cursor: pointer; }
        .logo { text-align: center; margin-bottom: 20px; font-size: 24px; }
        .warning { color: red; margin-top: 20px; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">Microsoft</div>
        <h2>Sign in</h2>
        <input type="email" placeholder="Email, phone, or Skype" />
        <input type="password" placeholder="Password" />
        <button>Sign in</button>
        <div class="warning">⚠️ SECURITY TRAINING SIMULATION - DO NOT ENTER REAL CREDENTIALS</div>
    </div>
</body>
</html>
EOF

    # Open in browser
    if command -v xdg-open &>/dev/null; then
        xdg-open "$phish_file" &
    elif command -v firefox &>/dev/null; then
        firefox "$phish_file" &
    fi

    echo -e "\033[32m[+] Phishing page deployed\033[0m"
    play_sound "success"

    sleep 30
    rm -f "$phish_file"
    exit 0
}

function run_crypto_miner() {
    clear
    echo -e "\033[36m[*] Cryptominer initialized\033[0m"
    echo "Mining pool: pool.supportxmr.com:443"
    echo "Wallet: 4$(random_hash 95)"
    echo

    local hashrate=0
    local total_hashes=0

    while ! should_stop; do
        should_pause

        hashrate=$((RANDOM % 500 + 100))
        total_hashes=$((total_hashes + hashrate))

        echo -e "\033[32m[$(date +%T)] Hashrate: ${hashrate} H/s | Total: ${total_hashes} hashes\033[0m"

        if ((RANDOM % 10 == 0)); then
            echo -e "\033[33m[+] Share accepted!\033[0m"
            play_sound "success"
        fi

        sleep 2
    done

    exit 0
}

# ============================================================================
# Master Controller
# ============================================================================

function run_master() {
    clear
    echo -e "\033[31m"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║    ADVANCED PERSISTENT THREAT - MASTER CONTROL NODE          ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "\033[0m"
    echo

    play_sound "critical"
    speak "Attack sequence initiated."

    local phase=0
    local modules_spawned=0
    local phase_modules=(1 1 2 2 3 3 5 8)  # Exponential spawning

    while ! should_stop; do
        should_pause

        if [[ $phase -lt ${#PHASE_NAMES[@]} ]]; then
            echo -e "\033[33m╔═══════════════════════════════════════════════════════╗\033[0m"
            echo -e "\033[33m║ PHASE $((phase + 1)): ${PHASE_NAMES[$phase]}$(printf '%*s' $((40 - ${#PHASE_NAMES[$phase]})) '')║\033[0m"
            echo -e "\033[33m╚═══════════════════════════════════════════════════════╝\033[0m"

            play_sound "warning"
            speak "Phase $((phase + 1)). ${PHASE_NAMES[$phase]}"

            # Spawn modules for this phase
            local spawn_count=${phase_modules[$phase]:-2}
            for ((i=0; i<spawn_count; i++)); do
                if should_stop; then break; fi

                local module="${MODULES[$((RANDOM % ${#MODULES[@]}))]}"
                echo "[$(date +%T)] Deploying module: $module"
                spawn_module "$module"
                modules_spawned=$((modules_spawned + 1))

                sleep "$SPAWN_DELAY"
            done

            phase=$((phase + 1))
            sleep $(random_between 20 40)
        else
            # Maintain chaos - keep spawning modules
            if ((RANDOM % 100 < RESPAWN_CHANCE)); then
                local module="${MODULES[$((RANDOM % ${#MODULES[@]}))]}"
                spawn_module "$module"
                sleep "$SPAWN_DELAY"
            fi
            sleep 5
        fi
    done

    # Cleanup and reveal
    echo
    echo -e "\033[32m╔══════════════════════════════════════════════════════════════╗\033[0m"
    echo -e "\033[32m║          KILLSWITCH ACTIVATED - TERMINATING                  ║\033[0m"
    echo -e "\033[32m╚══════════════════════════════════════════════════════════════╝\033[0m"
    echo
    echo -e "\033[36m[*] This was a SECURITY AWARENESS TRAINING simulation\033[0m"
    echo -e "\033[36m[*] No actual harm was done to your system\033[0m"
    echo -e "\033[36m[*] Remember: Never leave your computer unattended!\033[0m"
    echo

    speak "Training simulation complete."

    # Clean up all flag files
    rm -f "$FLAG_FILE" "$PAUSE_FLAG" "$MODULE_TRACKER" 2>/dev/null

    read -p "Press Enter to close all windows..."

    # Kill all spawned child processes
    pkill -P $$ 2>/dev/null

    exit 0
}

# ============================================================================
# Consent Screen
# ============================================================================

function show_consent() {
    clear
    echo
    echo -e "\033[31m  +======================================================================+\033[0m"
    echo -e "\033[31m  |                     !! WARNING - SYSTEM BREACH !!                    |\033[0m"
    echo -e "\033[31m  +======================================================================+\033[0m"
    echo -e "  |                                                                      |"
    echo -e "  |  An Advanced Persistent Threat has been detected on this system.    |"
    echo -e "  |                                                                      |"
    echo -e "  |  The following attack vectors have been compromised:                |"
    echo -e "\033[90m  |  - Network perimeter firewall                                       |\033[0m"
    echo -e "\033[90m  |  - Authentication systems                                           |\033[0m"
    echo -e "\033[90m  |  - System kernel modules                                            |\033[0m"
    echo -e "\033[90m  |  - Endpoint protection services                                     |\033[0m"
    echo -e "  |                                                                      |"
    echo -e "\033[33m  |  ALERT: Multiple attack modules deploying...                        |\033[0m"
    echo -e "  |                                                                      |"
    echo -e "\033[31m  |  Emergency Response:                                                |\033[0m"
    echo -e "\033[32m  |  Type 'secret' in any window to activate emergency shutdown         |\033[0m"
    echo -e "  |                                                                      |"
    echo -e "  |  Attack Profile: $INTENSITY                                              |"
    echo -e "\033[31m  |  Threat Level: CRITICAL                                             |\033[0m"
    echo -e "  |                                                                      |"
    echo -e "\033[31m  +======================================================================+\033[0m"
    echo

    read -p "  Press ENTER to continue, or Ctrl+C to abort: "
}

# ============================================================================
# Main Entry Point
# ============================================================================

function main() {
    case "$MODULE" in
        "Launcher")
            show_consent
            exec bash "$SCRIPT_PATH" "Master" 0 "$INTENSITY" "$MODE"
            ;;
        "Master")
            run_master
            ;;
        "Matrix")
            run_matrix
            ;;
        "Hex")
            run_hex
            ;;
        "Infection")
            run_infection
            ;;
        "Glitch")
            run_glitch
            ;;
        "Map")
            run_map
            ;;
        "Keylogger")
            run_keylogger
            ;;
        "LateralMovement")
            run_lateral_movement
            ;;
        "Ransomware")
            run_ransomware
            ;;
        "DataExfil")
            run_data_exfil
            ;;
        "Chat")
            run_chat
            ;;
        "BrowserCascade")
            run_browser_cascade
            ;;
        "PhishingSimulator")
            run_phishing_simulator
            ;;
        "CryptoMiner")
            run_crypto_miner
            ;;
        *)
            echo "Unknown module: $MODULE"
            exit 1
            ;;
    esac
}

# Handle killswitch input detection in background
function input_monitor() {
    local buffer=""
    while ! should_stop; do
        IFS= read -rsn1 char
        buffer+="$char"

        # Keep buffer manageable
        if [[ ${#buffer} -gt 20 ]]; then
            buffer="${buffer: -10}"
        fi

        # Check for secret word
        if [[ "$buffer" == *"secret"* ]]; then
            echo -e "\n\033[33m[!] Killswitch activated - Shutting down...\033[0m"
            touch "$FLAG_FILE"
            break
        fi
    done
}

# Start input monitor in background for all modules
input_monitor &
INPUT_MONITOR_PID=$!

# Run the main logic
main

# Clean up input monitor on exit
kill $INPUT_MONITOR_PID 2>/dev/null
wait $INPUT_MONITOR_PID 2>/dev/null

exit 0

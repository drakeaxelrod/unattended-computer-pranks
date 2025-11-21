# ============================================================================
# CYBER APOCALYPSE - UNSTOPPABLE EDITION
# ============================================================================
# WARNING: ULTRA PERSISTENT! Spawns multiple windows that respawn when closed!
# Type "S3cr3t" (no prompt) in ANY window to stop the madness!
# Closing windows won't help - they multiply! MUAHAHAHA!
# ============================================================================

param([switch]$child, [int]$generation = 0)

# Global flag file to stop all instances
$global:flagFile = "$env:TEMP\cyberApocalypseFlag.tmp"
$global:processTracker = "$env:TEMP\cyberApocalypseProcs.txt"

# Multiple ASCII Banners
$banners = @(
@"
   ██████╗██╗   ██╗██████╗ ███████╗██████╗      █████╗ ██████╗  ██████╗  ██████╗ █████╗ ██╗  ██╗   ██╗██████╗ ███████╗███████╗
  ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗    ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██╔══██╗██║  ╚██╗ ██╔╝██╔══██╗██╔════╝██╔════╝
  ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝    ███████║██████╔╝██║   ██║██║     ███████║██║   ╚████╔╝ ██████╔╝███████╗█████╗
  ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗    ██╔══██║██╔═══╝ ██║   ██║██║     ██╔══██║██║    ╚██╔╝  ██╔═══╝ ╚════██║██╔══╝
  ╚██████╗   ██║   ██████╔╝███████╗██║  ██║    ██║  ██║██║     ╚██████╔╝╚██████╗██║  ██║███████╗██║   ██║     ███████║███████╗
   ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝      ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝     ╚══════╝╚══════╝
"@,
@"
    ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗     ██████╗ ██████╗ ███╗   ███╗██████╗ ██████╗  ██████╗ ███╗   ███╗██╗███████╗███████╗██████╗
    ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║    ██╔════╝██╔═══██╗████╗ ████║██╔══██╗██╔══██╗██╔═══██╗████╗ ████║██║██╔════╝██╔════╝██╔══██╗
    ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║    ██║     ██║   ██║██╔████╔██║██████╔╝██████╔╝██║   ██║██╔████╔██║██║███████╗█████╗  ██║  ██║
    ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║    ██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██╔══██╗██║   ██║██║╚██╔╝██║██║╚════██║██╔══╝  ██║  ██║
    ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║    ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ██║  ██║╚██████╔╝██║ ╚═╝ ██║██║███████║███████╗██████╔╝
    ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝     ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚═╝╚══════╝╚══════╝╚═════╝
"@,
@"
    ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄       ▄▄▄▄▄▄▄▄▄▄▄  ▄            ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
   ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌     ▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
   ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌░▌   ▐░▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀
   ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌▐░▌ ▐░▌▐░▌     ▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌
   ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌ ▐░▐░▌ ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░▌          ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄
   ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌▐░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌     ▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
   ▐░▌       ▐░▌▐░█▀▀▀▀█░█▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌ ▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌   ▀   ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀
   ▐░▌       ▐░▌▐░▌     ▐░▌  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌     ▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌
   ▐░█▄▄▄▄▄▄▄█░▌▐░▌      ▐░▌ ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌     ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄
   ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
    ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀       ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀
"@
)

# Skull ASCII
$skull = @"
                                                     .
                                                   .n                   .                 .
                                .                 n#.                  .:                  :
                          .:  .      .         .:#o   .o:                        .:.
                   n. .n#   :o:    .n           on.     :#                .o       no    .n
                   :##o:     n     .#           ##       :o               :#       :#.    o
              ....   ....    #:    :o      .... ##.                       .o       .#.    :
              :ono   onn     :#    .o      onno .#o       o..oo:           o       .#o    o
              .:..   .:..    .#o.. :o      .:.. .oo      :nnonn#           #       .oo    :
                             .o#nnn#:                    o:..:o            ##.      oo    o
                             .::::::.                    o:..::            .#o:.    on    :
                                                          ::::              :n#n#o  :n    o
                   ░▒▓█  BREACH DETECTED  █▓▒░                              .::.   :#    :
                                                                                     ::    o
                                                                                     ::    :
"@

# Set up console
$titles = @(
    "⚠️ CRITICAL SYSTEM BREACH - CONTAINMENT FAILED ⚠️",
    "🔴 SECURITY ALERT - UNAUTHORIZED ACCESS 🔴",
    "💀 SYSTEM COMPROMISED - ALL DEFENSES DOWN 💀",
    "⚡ CYBER ATTACK IN PROGRESS ⚡",
    "🚨 MALWARE DETECTED - SPREADING RAPIDLY 🚨"
)
$host.UI.RawUI.WindowTitle = Get-Random $titles
$host.UI.RawUI.BackgroundColor = "Black"

# Color combinations
$colors = @('Red', 'Green', 'Yellow', 'Cyan', 'Magenta', 'White', 'DarkRed', 'DarkGreen', 'DarkYellow', 'DarkCyan', 'DarkMagenta')

# Fake computer names
$fakeComputers = @(
    "HR-SERVER-01", "FINANCE-DESK-17", "COFFEE-MACHINE-9000", "CEO-LAPTOP-OMEGA", "MAIL-SRV-ALPHA",
    "DEV-PC-42", "SECURITY-CAM-GRID", "DOOR-LOCK-SYSTEM", "POWER-GRID-MAIN", "BACKUP-GENERATOR",
    "CLIMATE-CONTROL", "ELEVATOR-MASTER", "JURASSIC-GATEWAY", "MAINFRAME-PRIME", "NUCLEAR-REACTOR-7",
    "DATABASE-OMEGA", "FIREWALL-NODE-9", "DNS-SERVER-DELTA", "PROXY-GATEWAY-5", "BACKUP-VAULT-X"
)

# Dramatic messages
$messages = @(
    "Establishing DinoLink™ connection...", "Activating Chaos Network Mode...", "Uploading RetroVirus 2.0...",
    "Bypassing Quantum Firewall...", "Re-routing through DARKNET nodes...", "Overloading Security Subsystems...",
    "Spreading Neural Infection Sequence...", "Initializing T-Rex Overwatch Protocol...",
    "Engaging Jurassic Expansion Chamber...", "Extracting biometric databases...", "Cloning administrator privileges...",
    "Injecting polymorphic code...", "Establishing Command & Control...", "Deploying rootkit payload...",
    "Harvesting encryption keys...", "Corrupting system logs...", "Disabling antivirus...", "Pivoting to domain controller...",
    "Lateral movement in progress...", "Exfiltrating classified data..."
)

# Check if should stop
function Should-Stop {
    return (Test-Path $global:flagFile)
}

# Register this process
function Register-Process {
    $pid | Out-File -Append -FilePath $global:processTracker
}

# Spawn new window with random position
function Spawn-NewWindow {
    param([int]$gen = 0)
    $newGen = $gen + 1
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -NoExit -WindowStyle Normal -File `"$PSCommandPath`" -child -generation $newGen"
}

# Monitor and respawn windows
function Start-WindowMonitor {
    $scriptBlock = {
        param($scriptPath, $flagFile, $procTracker, $currentPid, $gen)

        $spawnCount = 4
        $children = @()

        # Initial spawn
        for ($i = 0; $i -lt $spawnCount; $i++) {
            Start-Sleep -Milliseconds 500
            if (Test-Path $flagFile) { break }
            $proc = Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -NoExit -WindowStyle Normal -File `"$scriptPath`" -child -generation $($gen + 1)" -PassThru
            $children += $proc
        }

        # Monitor and respawn
        while (-not (Test-Path $flagFile)) {
            Start-Sleep -Seconds 2

            foreach ($proc in $children) {
                if ($proc.HasExited -and -not (Test-Path $flagFile)) {
                    # Respawn!
                    $newProc = Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -NoExit -WindowStyle Normal -File `"$scriptPath`" -child -generation $($gen + 1)" -PassThru
                    $children = $children | Where-Object { $_.Id -ne $proc.Id }
                    $children += $newProc
                }
            }

            # Add random additional window occasionally for chaos
            if ((Get-Random -Minimum 1 -Maximum 10) -eq 5 -and $children.Count -lt 8) {
                $newProc = Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -NoExit -WindowStyle Normal -File `"$scriptPath`" -child -generation $($gen + 1)" -PassThru
                $children += $newProc
            }
        }

        # Cleanup
        foreach ($proc in $children) {
            if (-not $proc.HasExited) {
                Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
            }
        }
    }

    Start-Job -ScriptBlock $scriptBlock -ArgumentList $PSCommandPath, $global:flagFile, $global:processTracker, $PID, $generation | Out-Null
}

# Type text with glitch effect
function Type-Text {
    param([string]$text, [string]$color = 'Green', [int]$speed = 20, [switch]$glitch)
    foreach ($char in $text.ToCharArray()) {
        if (Should-Stop) { return }

        if ($glitch -and (Get-Random -Minimum 1 -Maximum 10) -eq 5) {
            $glitchChar = Get-Random -InputObject @('█', '▓', '▒', '░', '@', '#', '$', '%', '&', '*')
            Write-Host $glitchChar -NoNewline -ForegroundColor (Get-Random $colors)
            Start-Sleep -Milliseconds 50
            Write-Host "`b$char" -NoNewline -ForegroundColor $color
        } else {
            Write-Host $char -NoNewline -ForegroundColor $color
        }
        Start-Sleep -Milliseconds $speed
    }
    Write-Host ""
}

# Matrix effect
function Show-Matrix {
    param([int]$lines = 15, [switch]$intense)
    $chars = if ($intense) { @('█', '▓', '▒', '░', '╔', '╗', '╚', '╝', '║', '═', 'X', '0', '1') } else { @('0', '1', '█', '▓', '▒', '░', 'X', '*', '#', '>', '<', '/', '\', '|') }

    for ($i = 0; $i -lt $lines; $i++) {
        if (Should-Stop) { return }
        $randomText = -join ((0..100) | ForEach-Object { Get-Random -InputObject $chars })
        Write-Host $randomText -ForegroundColor (Get-Random -InputObject $colors)
        Start-Sleep -Milliseconds 10
    }
}

# Progress bar
function Show-HackProgress {
    param([string]$task, [string]$color = 'Cyan', [switch]$fast)
    Write-Host "`n  [$task]" -ForegroundColor $color
    $progress = 0
    $maxDelay = if ($fast) { 80 } else { 150 }

    while ($progress -lt 100) {
        if (Should-Stop) { return }
        $progress += Get-Random -Minimum 5 -Maximum 25
        if ($progress -gt 100) { $progress = 100 }

        $bar = "█" * [math]::Floor($progress / 2)
        $space = "░" * (50 - [math]::Floor($progress / 2))
        Write-Host "`r  $bar$space $progress%" -NoNewline -ForegroundColor $color
        Start-Sleep -Milliseconds (Get-Random -Minimum 20 -Maximum $maxDelay)
    }
    Write-Host "`r  $('█' * 50) 100% ✓ COMPLETE" -ForegroundColor Green
}

# Infection spread
function Show-InfectionSpread {
    param([int]$duration = 20)
    $startTime = Get-Date

    while (((Get-Date) - $startTime).TotalSeconds -lt $duration) {
        if (Should-Stop) { return }

        $remaining = $duration - [int]((Get-Date) - $startTime).TotalSeconds
        $pc = Get-Random $fakeComputers
        $msg = Get-Random $messages

        Write-Host "`n  ╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Red
        Write-Host ("  ║ ⚠️  INFECTION SPREADING - NODES COMPROMISED: {0,-15} ║" -f "$remaining") -ForegroundColor Yellow
        Write-Host "  ╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Red
        Write-Host ("    ► TARGET NODE: {0}" -f $pc) -ForegroundColor Cyan
        Write-Host ("    ► STATUS: {0}" -f $msg) -ForegroundColor Magenta

        if ($remaining % 7 -eq 0) {
            Write-Host "`n    🔴🔴🔴 CRITICAL NODE EXPANSION DETECTED 🔴🔴🔴" -ForegroundColor DarkRed
            [console]::beep(1000, 100)
        }

        if ($remaining % 10 -eq 0) {
            Write-Host "`n             ╔═══════════════════╗" -ForegroundColor Red
            Write-Host "             ║  ACCESS DENIED    ║" -ForegroundColor Red -BackgroundColor DarkRed
            Write-Host "             ║  ACCESS DENIED    ║" -ForegroundColor Red -BackgroundColor DarkRed
            Write-Host "             ║  ACCESS DENIED    ║" -ForegroundColor Red -BackgroundColor DarkRed
            Write-Host "             ╚═══════════════════╝" -ForegroundColor Red
        }

        Start-Sleep -Milliseconds 400
    }
}

# Glitch effect
function Show-Glitch {
    param([int]$intensity = 5)
    for ($i = 0; $i -lt $intensity; $i++) {
        if (Should-Stop) { return }
        $glitchText = -join ((0..120) | ForEach-Object { Get-Random -InputObject @('█', '▓', '▒', '░', '/', '\', '|', '-', 'X') })
        $bg = Get-Random -InputObject @('Black', 'DarkRed', 'DarkBlue')
        Write-Host $glitchText -ForegroundColor (Get-Random $colors) -BackgroundColor $bg
    }
}

# Password listener
function Start-PasswordListener {
    $scriptBlock = {
        param($flagFile)
        $password = ""
        $target = "S3cr3t"

        while ($true) {
            if (Test-Path $flagFile) { break }

            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                $password += $key.KeyChar

                if ($password.Length -gt 6) {
                    $password = $password.Substring($password.Length - 6)
                }

                if ($password -eq $target) {
                    New-Item -Path $flagFile -ItemType File -Force | Out-Null
                    break
                }
            }
            Start-Sleep -Milliseconds 50
        }
    }

    Start-Job -ScriptBlock $scriptBlock -ArgumentList $global:flagFile | Out-Null
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

Register-Process
Clear-Host

if (-not $child) {
    # PARENT WINDOW - Master Controller
    $banner = Get-Random $banners
    Write-Host $banner -ForegroundColor Red
    Write-Host "`n"
    Type-Text "  ⚡ INITIALIZING MULTI-VECTOR CYBER ATTACK ⚡" "Red" 25 -glitch
    Type-Text "  ⚡ SPAWNING DISTRIBUTED ATTACK NODES... ⚡" "Yellow" 25
    Type-Text "  ⚡ PERSISTENCE MODE: ULTRA AGGRESSIVE ⚡" "Magenta" 25
    Write-Host "`n"

    Show-Matrix -lines 8 -intense
    Write-Host "`n"

    # Start the window monitor that will spawn and respawn children
    Start-WindowMonitor

    Type-Text "  ✓ ATTACK VECTORS DEPLOYED AND MONITORED" "Green" 20
    Type-Text "  ✓ AUTO-RESPAWN ENABLED - RESISTANCE IS FUTILE" "Green" 20
    Write-Host "`n"
    Show-Glitch -intensity 3
    Start-Sleep -Seconds 2
}

# Start password listener
Start-PasswordListener

# ============================================================================
# MAIN CHAOS LOOP
# ============================================================================

$loopCount = 0
while (-not (Should-Stop)) {
    $loopCount++
    Clear-Host

    # Random banner each time
    $banner = Get-Random $banners
    Write-Host $banner -ForegroundColor (Get-Random @('Red', 'DarkRed', 'Magenta'))

    # Show skull occasionally
    if ($loopCount % 3 -eq 0) {
        Write-Host $skull -ForegroundColor Red
    }

    Write-Host "`n"
    Write-Host "  ╔══════════════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "  ║     >>> CYBER APOCALYPSE CONTROL - GENERATION: $generation <<<        " -ForegroundColor Yellow
    Write-Host "  ║        >>> CONTAINMENT FAILED - SPREADING UNCONTROLLABLY <<<         ║" -ForegroundColor Yellow
    Write-Host "  ╚══════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow

    # Random attack sequence
    $sequence = Get-Random -Minimum 1 -Maximum 8

    switch ($sequence) {
        1 {
            Write-Host "`n  [🔴 PHASE 1: NETWORK INFILTRATION 🔴]`n" -ForegroundColor Cyan
            Show-Matrix -lines 12 -intense
            Show-HackProgress "PENETRATING FIREWALL" "Red" -fast
            Show-HackProgress "ESCALATING PRIVILEGES" "Yellow" -fast
            Show-HackProgress "BYPASSING IDS/IPS" "Magenta" -fast
        }
        2 {
            Write-Host "`n  [💀 PHASE 2: DATA EXFILTRATION 💀]`n" -ForegroundColor Magenta
            Show-InfectionSpread -duration 15
        }
        3 {
            Write-Host "`n  [⚡ PHASE 3: TOTAL SYSTEM TAKEOVER ⚡]`n" -ForegroundColor Red
            $files = @(
                "//CLASSIFIED/GOVERNMENT/AREA51.DAT",
                "//TOPSECRET/MILITARY/LAUNCH_CODES.SYS",
                "//SYSTEM/ROOT/MASTER_KEY.DB",
                "//CORPORATE/CEO/BANK_ACCOUNTS.XLS",
                "//PERSONAL/PHOTOS/EMBARRASSING_PICS.ZIP",
                "//SECURITY/PASSWORDS/ALL_USERS.HASH"
            )

            foreach ($file in $files) {
                if (Should-Stop) { break }
                Type-Text "    ► ACCESSING: $file" "Red" 8 -glitch
                Show-HackProgress "DOWNLOAD" (Get-Random -InputObject @('Red', 'Yellow', 'Magenta')) -fast
            }
        }
        4 {
            Write-Host "`n  [🔥 PHASE 4: CHAOS PROPAGATION 🔥]`n" -ForegroundColor Yellow
            Show-Matrix -lines 15 -intense

            for ($i = 0; $i -lt 20; $i++) {
                if (Should-Stop) { break }
                $msg = Get-Random -InputObject @(
                    ">> DEPLOYING MALWARE TO NODE $i...",
                    ">> CORRUPTING DATABASE SECTOR $i...",
                    ">> HIJACKING CONTROL SYSTEM $i...",
                    ">> ESTABLISHING BACKDOOR $i...",
                    ">> INJECTING ROOTKIT INTO KERNEL $i..."
                )
                Write-Host "  $msg" -ForegroundColor (Get-Random -InputObject $colors)
                Start-Sleep -Milliseconds (Get-Random -Minimum 50 -Maximum 200)
            }
        }
        5 {
            Write-Host "`n  [💣 PHASE 5: DISTRIBUTED DENIAL OF SANITY 💣]`n" -ForegroundColor DarkRed
            Show-Glitch -intensity 10
            Type-Text "  >> OVERWHELMING VISUAL CORTEX..." "Red" 15
            Type-Text "  >> DEPLOYING CONFUSION ALGORITHMS..." "Yellow" 15
            Type-Text "  >> MAXIMIZING SCREEN CHAOS..." "Magenta" 15
            Show-Matrix -lines 20 -intense
        }
        6 {
            Write-Host "`n  [🌐 PHASE 6: LATERAL MOVEMENT 🌐]`n" -ForegroundColor Cyan
            for ($i = 0; $i -lt 8; $i++) {
                if (Should-Stop) { break }
                $src = Get-Random $fakeComputers
                $dst = Get-Random $fakeComputers
                Type-Text "  ► PIVOTING: $src → $dst" "Cyan" 10
                Show-HackProgress "ESTABLISHING TUNNEL" "Green" -fast
            }
        }
        7 {
            Write-Host "`n  [👁️ PHASE 7: SURVEILLANCE ACTIVATION 👁️]`n" -ForegroundColor DarkYellow
            $devices = @("WEBCAM-01", "MICROPHONE-ARRAY", "SCREEN-CAPTURE", "KEYLOGGER", "GPS-TRACKER", "BIOMETRIC-SCANNER")
            foreach ($device in $devices) {
                if (Should-Stop) { break }
                Type-Text "  ► ACTIVATING: $device" "Yellow" 12
                Show-HackProgress "STREAMING DATA" "Yellow" -fast
            }
        }
    }

    # Countdown
    if (-not (Should-Stop)) {
        Write-Host "`n`n  [💀 POINT OF NO RETURN APPROACHING 💀]`n" -ForegroundColor Red
        for ($i = 10; $i -gt 0; $i--) {
            if (Should-Stop) { break }
            Write-Host "`r  ⚠️⚠️⚠️  CATASTROPHIC FAILURE IN: $i SECONDS  ⚠️⚠️⚠️  " -NoNewline -ForegroundColor Red -BackgroundColor Yellow
            if ($i % 2 -eq 0) { [console]::beep(800, 100) }
            Start-Sleep -Seconds 1
        }
    }

    if (-not (Should-Stop)) {
        Show-Glitch -intensity 8
        Show-Matrix -lines 30 -intense
        Start-Sleep -Milliseconds 500
    }
}

# ============================================================================
# CLEANUP AND EXIT
# ============================================================================

Clear-Host
Write-Host "`n`n`n`n"
Write-Host "  ╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║                                                                    ║" -ForegroundColor Green
Write-Host "  ║                ✓✓✓ SECRET CODE ACCEPTED ✓✓✓                       ║" -ForegroundColor Green
Write-Host "  ║                                                                    ║" -ForegroundColor Green
Write-Host "  ║              CYBER APOCALYPSE TERMINATED                           ║" -ForegroundColor Green
Write-Host "  ║              ALL ATTACK VECTORS NEUTRALIZED                        ║" -ForegroundColor Green
Write-Host "  ║              SYSTEMS RESTORED                                      ║" -ForegroundColor Green
Write-Host "  ║                                                                    ║" -ForegroundColor Green
Write-Host "  ║              Just kidding! This was an epic prank! 🎭             ║" -ForegroundColor Cyan
Write-Host "  ║              No actual hacking occurred.                           ║" -ForegroundColor Cyan
Write-Host "  ║              Your system is completely safe.                       ║" -ForegroundColor Cyan
Write-Host "  ║                                                                    ║" -ForegroundColor Green
Write-Host "  ╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green

# Cleanup
if (Test-Path $global:flagFile) {
    Remove-Item $global:flagFile -Force -ErrorAction SilentlyContinue
}
if (Test-Path $global:processTracker) {
    Remove-Item $global:processTracker -Force -ErrorAction SilentlyContinue
}

Get-Job | Remove-Job -Force

Write-Host "`n  Thanks for playing CYBER APOCALYPSE! 💀" -ForegroundColor Gray
Write-Host "  This window will close in 5 seconds..." -ForegroundColor Gray
Start-Sleep -Seconds 5

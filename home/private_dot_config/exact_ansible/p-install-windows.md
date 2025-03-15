1. Uninstall bloat using "Add or remove programs"
1. Firefox:
   1. `winget install mozilla.firefox`
   1. Sign into Mozilla Firefox and Sign in to Bitwarden
   1. Copy Vimium settings (See Appendix)
   1. Set Firefox as Default
1. Dotfiles
   1. Turn on Developer Mode: `Settings > For Developers > Deverlop Mode`
   1. Chezmoi 1.`winget install microsoft.powershell ajeetdsouza.zoxide git.git bitwarden.cli twpayne.chezmoi `
      1. Login to bitwarden and unlock vault (use "$env:BW_SESSION=..." to set session)
      1. Create `~/.ssh/.age_private_key.txt` with "ChezMoi Dotfiles Manager / age_private_key" from Bitwarden
      1. Apply dotfiles `chezmoi init quitlox --apply`
   1. Configure Windows Terminal:
      1. Set "PowerShell 7" as Default
      1. Create "PowerShell (Admin)" Profile
1. PowerToys
   1. `winget install Microsoft.powertoys`
   1. Run as administrator and set "General > Always run as administrator"
   1. Restore backup (in General) from `~/Documents/PowerToys/Backup/...`
   - Changes Made:
     - Swap Escape and Capslock in PowerToys
1. [OpenSSH](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=powershell)

   - In PowerShell Administrator:

   ```powershell
   # Install the OpenSSH Client
   Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
   # Install the OpenSSH Server
   Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

   # Start the sshd service
   Start-Service sshd

   # OPTIONAL but recommended:
   Set-Service -Name sshd -StartupType 'Automatic'

   # Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
   if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
       Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
       New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
   } else {
       Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
   }
   ```

1. Windows Settings
   1. Keyboard
      1. Keyboard Layouts
         - English (United Kingdom) with US keyboard
         - Dutch (Netherlands) with US-International keyboard
         - Korean
      1. Switching Layout with Alt+Shift
         1. Settings > Time & language > Typing > Advanced keyboard settings
            - > Input language hot keys > Change Key Sequence > Enable "Between input languages"
   2. Dualboot Time UTC
      ```powershell
      reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f
      ```
   3. [Long File Paths](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=powershell)
   ```powershell
   New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
   ```
1. System
   1. Drivers
      1. AMD Adrenaline: https://www.amd.com/en/support/download/drivers.html
      2. Intel Drivers: https://www.intel.com/content/www/us/en/support/detect.html
         - Wifi, Bluetooth
      3. Gigabyte: https://www.gigabyte.com/Motherboard/X570-AORUS-ELITE-rev-10/support#support-dl-driver-audio
         - Intel Network Connections
         - Realteak Audio Driver
         - AMD Chipset Driver
   2. RGB
      - OpenRGB: `winget install CalcProgrammer1.OpenRGB`
      - L-Connect 3: `winget install LianLi.LConnect3`
   3. Other
      - HardwareInfo: `winget install REALiX.HWiNFO`
1. WSL
   - `wsl --install --no-distribution`
   - [Install Arch](https://wsldl-pg.github.io/ArchW-docs/How-to-Setup/)
     - Simply download and run ArchOnline.exe
1. Applications
   1. Games
      1. Steam: `winget install valve.steam`
         - Add D:/Games/SteamLibrary as library (no config changes needed)
      2. EA: `winget install electronicarts.eadesktop`
      3. Ubisoft: `winget install ubisoft.connect`
      4. Battle.net: No winget yet
      5. Rockstar: No winget yet
      6. Playnite: `winget install playnite.playnite`
      7. Install DZSALauncher
      8. Install [Stardrop](https://github.com/Floogen/Stardrop/releases/latest)
   1. User Applications
      - Obsidian: `winget install obsidian.obsidian`
      - Zotero: `winget install digitalscholar.zotero`
      - Todoist: `winget install doist.todoist`
      - Thunderbird: `winget install mozilla.thunderbird`
        - Add Dutch Language pack and Dictionary
        - Set "Privacy & Security > Junk > When I mark messages as junk: Move them to the account's Junk folder"
        - "Account Settings > Junk Settings > Destination and Retention > Move new junk messages to: Spam"
        - Set "Table View" in Inbox
        - Set "Hamburger > View > Layout to 'Classic View'"
      - No Configuration
        - QBittorrent: `winget install qbittorrent.qbittorrent`
   1. Command Line
      - Neovim: `winget install neovim neovide sqlite ripgrep`
      - `winget install waterlan.dos2unix`
   1. Development
      - `winget install kitware.cmake`
      - `winget install microsoft.openjdk.11`
   1. Tools
      - `winget install 7zip.7zip
      - `winget install rufus.rufus`
      - `winget install uderzosoftware.spacesniffer'
      - `winget install SSHFS-Win.SSHFS-Win`
      - Windows Tools:
        `winget install winscp.winscp microsoft.sysinternals.pstools`
   1. [Office](https://massgrave.dev/#method_1_-_powershell)
      - Install Office (see website above for correct official link)
      - `irm https://get.activated.win | iex`
        - select ohook method
   1. Miscellenous
      1. `winget install 9MVZQVXJBQ9V` # AV1 Video Extension
1. Wacom
   1. Install `winget install wacom.wacomtabletdriver`
1. Sunshine
   1. Install and Configure [webOS Dev Manager](https://github.com/webosbrew/dev-manager-desktop/releases/latest)
   1. Install `winget install vigem.vigembus lizardbyte.sunshin`
   1. Download [resolution_change.exe](https://github.com/designer-living/sunshine_utils/releases/latest) and extract to `~/Applications/resolution_change.exe`
   1. Copy `{{ chezmoi }}/windows/sunshine/apps.json` to `C:/Program Files/Sunshine/config/apps.json`
   1. Log into Sunshine and create account at https://localhost:47990/

TODO:

- Setup StardewValley
- Setup Arch

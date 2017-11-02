# ============================================================================
# Name		: Windows Server Post Configuration
# Author	: Peter van Barneveld  
# Date		: 01-11-2017
# Edit		: 01-11-2017
# Version	: 1.0
# 
# Description:
# 
#
# ============================================================================
#
# Script tested on: 
# - Windows Server 2016
#
# ============================================================================

# Check if OS build version is compatible, exit if not compatible
# ===============================================================
$os = [System.Environment]::OSVersion.Version
switch ($os.build) 
    { 
        "14393" {"Windows Server 2016 is compatible"}
        Default {Exit}
	}

# Create Default Directories
# ==========================
New-Item -type directory -path C:\Temp
New-Item -type directory -path C:\Xcellent
New-Item -type directory -path C:\Xcellent\Certificate
New-Item -type directory -path C:\Xcellent\Log
New-Item -type directory -path C:\Xcellent\Reports
New-Item -type directory -path C:\Xcellent\Reports\DocuExport
New-Item -type directory -path C:\Xcellent\Scripts

# Change Bootmanager Timeout setting
# ==================================
bcdedit.exe /timeout 5

# Set RDP protocol settings and Default RDSH Settings
# ===================================================
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" "fDenyTSConnections" -value 0
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" "fSingleSessionPerUser" -value 0
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" "fDisableCcm" -value 1
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" "fDisableCdm" -value 1
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" "fDisableCpm" -value 1
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" "fDisableLPT" -value 1
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" "fForceClientLptDef" -value 0
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" "fDisablePNPRedir" -value 1

# Enable Ignore Remote Keyboard Layout
# ====================================
Set-ItemProperty -path "HKLM:\System\CurrentControlSet\Control\Keyboard Layout" "IgnoreRemoteKeyboardLayout" "1" -Type "dword"

# Regional Settings to Dutch and Location to Netherlands
# ======================================================
Set-Culture 1043
Set-WinHomeLocation 176

# Keyboard Language to Dutch
Set-WinUserLanguageList nl-NL -force

# Disable Windows Error reporting (WER)
Disable-WindowsErrorReporting

# Firewall instellingen / aanpassingen
# ====================================

# Enable RDP in Firewall Public,Private,Domain
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Enable WMI in Firewall Public,Private,Domain
Enable-NetFirewallRule -DisplayGroup "Windows Management Instrumentation (WMI)"

# Enable PING (Echo-IN) in Firewall voor Domain,Private
Set-NetFirewallRule -Name "FPS-ICMP4-ERQ-In" -enabled True -Profile "Domain,Private"

# Instellen Powerplan op High Performance
# =======================================
$HighPerf = powercfg /l | %{if($_.contains("High performance")) {$_.split()[3]}}
$CurrPlan = $(powercfg /getactivescheme).split()[3]
if ($CurrPlan -ne $HighPerf) {powercfg /setactive $HighPerf}


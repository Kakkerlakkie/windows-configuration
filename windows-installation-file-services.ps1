# ============================================================================
# Name		: Windows Server File Services Installation
# Author	: Peter van Barneveld  
# Date		: 09-11-2017
# Edit		: 09-11-2017
# Version	: 1.0
# 
# Description:
# Script to install Windows File Services
#
# ============================================================================
#
# Script tested on: 
# - Windows Server 2012 R2
# - Windows Server 2016
#
# Requirements:
# - Powershell 3.0 or higher
#
# ============================================================================

# Enable File Browse for File Servers(SMS In) in Firewall voor Domain,Private
# ===========================================================================
Set-NetFirewallRule -Name "FPS-SMB-In-TCP" -enabled True -Profile "Domain,Private"

# Default folder structure on F: drive
# ====================================

$Fpresent = Get-PSDrive F  
if ($Fpresent) {
    New-Item -type directory -path f:\Data
    New-Item -type directory -path f:\Data\Users
    New-Item -type directory -path f:\Data\Install
    net share "Users$=f:\Data\Users" "/GRANT:Everyone,FULL"  "/cache:no"
    net share "Install$=f:\Data\Install" "/GRANT:Everyone,FULL" "/cache:no"
    icacls f:\Data /inheritance:r
    icacls f:\Data /grant 'Administrators:(OI)(CI)F' 'SYSTEM:(OI)(CI)F' 'USERS:(OI)(CI)RX'
    icacls f:\Data\users /inheritance:r
    icacls f:\Data\users /grant 'Administrators:(OI)(CI)F' 'SYSTEM:(OI)(CI)F' 'USERS:(RX,AD)' 'CREATOR OWNER:(OI)(CI)(IO)F'
    } {# F: drive is not present
}

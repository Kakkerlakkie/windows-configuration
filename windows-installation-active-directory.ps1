# ============================================================================
# Name		: Windows Server Active Directory Installation
# Author	: Peter van Barneveld  
# Date		: 07-11-2017
# Edit		: 07-11-2017
# Version	: 1.0
# 
# Description:
# Script to install Active Directory Domain Controllers
#
# ============================================================================
#
# Script tested on: 
# - Windows Server 2016
#
# Requirements:
# - Powershell 3.0 or higher
#
# ============================================================================

# Check if OS build version is compatible, exit if not compatible
# ===============================================================
$os = [System.Environment]::OSVersion.Version
switch ($os.build) {
    "14393" {"Windows Server 2016 is compatible"}
    Default {Exit}
}

# Install AD-Domain-Services
# ==========================
Install-windowsfeature -name AD-Domain-Services –IncludeManagementTools

# Choose DC installation type
# ===========================
$title = "Choose DC Installation Type"
$message = "
A = Install DC for new forest
B = Install DC for new child domain
C = Install DC into existing domain
"
$dc1 = New-Object System.Management.Automation.Host.ChoiceDescription "&a","Install DC for new forest"
$dc2 = New-Object System.Management.Automation.Host.ChoiceDescription "&b","Install DC for new child domain"
$dc3 = New-Object System.Management.Automation.Host.ChoiceDescription "&c","Install DC into existing domain"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($dc1, $dc2, $dc3)
$dcresult = $host.ui.PromptForChoice($title, $message, $options, 2) 

# Install DC for new forest
# =========================
If ($dcresult -match "0") {
    # Install-ADDSDomainController `
    # -DomainName (Read-Host "Domain FQDN to promote into") `
    # -Force:$true `
    # -InstallDns:$true
}

# Install DC for new child domain
# ===============================
If ($dcresult -match "1") {
    # Install-ADDSDomainController `
    # -DomainName (Read-Host "Domain FQDN to promote into") `
    # -Force:$true `
    # -InstallDns:$true
}

# Install DC into existing domain
# ===============================
If ($dcresult -match "2") {
    $DomainName = Get-ADDomain
    $DomainName = $DomainName.DNSRoot
    $title = "DomainName"
    $message = "
    Do you want to install the Domain Controller into the following domain:

    $DomainName
    "
    $Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
        "Yes"
    $No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
        "No"
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes,$No)
    $DomainNameChoice = $host.ui.PromptForChoice($title, $message, $options, 1)
    If ($DomainNameChoice -match 1) {
        $DomainName = Read-Host "Domain FQDN to promote into"
    }
    If ($DomainNameChoice -match 0) {
        Install-ADDSDomainController `
        -DomainName $DomainName `
        -Force:$true `
        -InstallDns:$true
    }
}

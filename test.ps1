# ============================================================================
# Name		: Windows Server Post Configuration
# Author	: Peter van Barneveld  
# Date		: 01-11-2017
# Edit		: 01-11-2017
# Version	: 1.0
# 
# Description:
# Test Github
#
# ============================================================================
#
# Script tested on: 
# - Windows Server 2016
#
# ============================================================================


# Create Default Directories
# ==========================
New-Item -type directory -path C:\Temp
New-Item -type directory -path C:\Xcellent
New-Item -type directory -path C:\Xcellent\Certificate
New-Item -type directory -path C:\Xcellent\Log
New-Item -type directory -path C:\Xcellent\Reports
New-Item -type directory -path C:\Xcellent\Reports\DocuExport
New-Item -type directory -path C:\Xcellent\Scripts

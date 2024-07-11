<#
.SYNOPSIS
Initiates a System File Checker (SFC) scan using PowerShell.

.DESCRIPTION
This script initiates an SFC scan to check and repair system files integrity on a Windows system.

.EXAMPLE
.\Invoke-SFCScan.ps1
Initiates a System File Checker scan.

.NOTES
Author: Kaleb Weise
Date: July 2024
Version: 1.0
#>

[CmdletBinding()]
param(
)

function Invoke-SFCScan {
  process {
    Write-Output "Initiating System File Checker scan..."

    # Run SFC scan using PowerShell cmdlet
    sfc /scannow
  }
}

# Call the function to initiate the SFC scan
Invoke-SFCScan

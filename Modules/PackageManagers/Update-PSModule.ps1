<#
.SYNOPSIS
Updates PowerShell modules installed on the system.

.DESCRIPTION
This script updates all installed PowerShell modules to their latest versions.

.EXAMPLE
.\Update-PSModule.ps1
Updates all PowerShell modules.

.NOTES
Author: Kaleb Weise
Date: July 2024
Version: 1.0
#>

[CmdletBinding()]
param(
)

function Update-PSModules {
  process {
    Write-Output "Updating PowerShell modules..."

    # Get a list of installed modules and update each one
    Get-Module -ListAvailable | ForEach-Object {
      Update-Module -Name $_.Name -Force
    }
  }
}

# Call the function to update PowerShell modules
Update-PSModules

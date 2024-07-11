<#
.SYNOPSIS
Updates Scoop packages on a Windows system.

.DESCRIPTION
This script updates all installed Scoop packages to their latest versions.

.EXAMPLE
.\Update-Scoop.ps1
Updates all Scoop packages.

.NOTES
Author: Kaleb Weise
Date: July 2024
Version: 1.0
#>

[CmdletBinding()]
param(
)

function Update-ScoopPackages {
  process {
    Write-Output "Updating Scoop packages..."

    # Update Scoop packages using the Scoop command
    scoop update *
  }
}

# Call the function to update Scoop packages
Update-ScoopPackages

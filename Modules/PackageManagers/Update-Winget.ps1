<#
.SYNOPSIS
Updates Windows Package Manager (winget) packages on a Windows system.

.DESCRIPTION
This script updates all installed packages managed by Windows Package Manager (winget) to their latest versions.

.EXAMPLE
.\Update-Winget.ps1
Updates all winget packages.

.NOTES
Author: Kaleb Weise
Date: July 2024
Version: 1.0
#>

[CmdletBinding()]
param(
)

function Update-WingetPackages {
  process {
    Write-Output "Updating winget packages..."

    # Update winget packages using the winget command
    winget upgrade --all
  }
}

# Call the function to update winget packages
Update-WingetPackages

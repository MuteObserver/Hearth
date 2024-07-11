<#
.SYNOPSIS
Updates Chocolatey packages on a Windows system.

.DESCRIPTION
This script updates all installed Chocolatey packages to their latest versions.

.EXAMPLE
.\Update-Chocolatey.ps1
Updates all Chocolatey packages.

.NOTES
Author: Kaleb Weise
Date: July 2024
Version: 1.0
#>

[CmdletBinding()]
param(
)

function Update-ChocolateyPackages {
  process {
    Write-Output "Updating Chocolatey packages..."

    # Update Chocolatey packages using the Chocolatey command
    choco upgrade all -y
  }
}

# Call the function to update Chocolatey packages
Update-ChocolateyPackages

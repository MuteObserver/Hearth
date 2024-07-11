<#
.SYNOPSIS
Initiates a Windows Defender scan using PowerShell.

.DESCRIPTION
This script initiates a quick scan using Windows Defender to check for malware and other security threats on the system.

.PARAMETER FullScan
Specifies whether to perform a full scan instead of a quick scan.

.PARAMETER ScanNetworkFiles
Specifies whether to scan network files during the scan.

.EXAMPLE
.\Invoke-DefenderScan.ps1 -FullScan
Initiates a full Windows Defender scan.

.EXAMPLE
.\Invoke-DefenderScan.ps1 -ScanNetworkFiles
Initiates a Windows Defender scan and includes network files.

.NOTES
Author: Kaleb Weise
Date: July 2024
Version: 1.0
#>

[CmdletBinding()]
param(
  [switch]$FullScan,
  [switch]$ScanNetworkFiles
)

function Invoke-DefenderScan {
  process {
    $scanType = "QuickScan"
    if ($FullScan) {
      $scanType = "FullScan"
    }

    Write-Output "Initiating Windows Defender $scanType..."

    # Perform the scan using Windows Defender cmdlet
    Start-MpScan -ScanType $scanType -ScanParameter @{ ScanNetworkFiles = $ScanNetworkFiles }
  }
}

# Call the function to initiate the scan
Invoke-DefenderScan

<#
.SYNOPSIS
Performs disk cleanup operations using PowerShell.

.DESCRIPTION
This script performs disk cleanup operations using built-in PowerShell cmdlets to remove unnecessary files from the system.

.PARAMETER IncludeDownloads
Specifies whether to include downloaded files in the cleanup.

.PARAMETER IncludeSystemFiles
Specifies whether to include system files in the cleanup.

.PARAMETER Confirm
Prompts for confirmation before performing the cleanup.

.EXAMPLE
.\Invoke-DiskCleanup.ps1 -IncludeDownloads -Confirm
Performs a disk cleanup, including downloaded files, and prompts for confirmation.

.EXAMPLE
.\Invoke-DiskCleanup.ps1 -IncludeSystemFiles -Confirm
Performs a disk cleanup, including system files, and prompts for confirmation.

.NOTES
Author: Kaleb Weise
Date: July 2024
Version: 1.0
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param (
    [switch]$IncludeDownloads,
    [switch]$IncludeSystemFiles,
    [switch]$Confirm = $true
)

function Invoke-DiskCleanup {
    process {
        $params = @{}
        if ($PSCmdlet.ShouldProcess("Performing disk cleanup")) {
            if ($IncludeDownloads) {
                $params.Add("DownloadedProgramFiles", $true)
                $params.Add("DownloadedFiles", $true)
            }
            if ($IncludeSystemFiles) {
                $params.Add("WindowsUpdateFiles", $true)
                $params.Add("WindowsUpgradeLogFiles", $true)
                $params.Add("SystemErrorMemoryDumpFiles", $true)
                $params.Add("SystemErrorMinidumpFiles", $true)
            }

            $cleanupOptions = New-Object -ComObject Shell.Application
            $cleanupOptions.Namespace(0x8) | ForEach-Object {
                $params.Keys | ForEach-Object {
                    $_
                    $_.InvokeVerb("Properties")
                }
            }
        confirmation perform disk cleanup, contains system Shodan
# Requires -RunAsAdministrator
# Requires -Version 5.1

<#
.SYNOPSIS
    Hearth - A comprehensive system maintenance utility for Windows.
.DESCRIPTION
    Automates common system maintenance tasks including package updates,
    system cleanup, security checks, and Windows updates. Handles first-time
    installation and repair seamlessly.
.NOTES
    File Name      : Hearth.ps1
    Author         : Kaleb Weise (A *Mute Observer)
    Version        : 1.0.0
#>

# ASCII Art Logo
$logo = @'
    /\                      ╔══════════════════════════════════╗
   /  \                     ║        Welcome to Hearth         ║
  /____\                    ║ -------------------------------- ║
 /|    |\     _____         ║ Automated System Maintenance     ║
/_|____| \   (     )        ║        for Windows               ║
  |    |     \   /          ║                                  ║
  |  []|      \ /           ║ Version: 1.0.0                   ║
  |____|_______V______      ║ Author: Kaleb Weise (A *Mute Observer)║
  |    |  _    |      |     ║ © 2024 Hearth Solutions          ║
  |    | (_)   |  []  |     ║                                  ║
  |____|______ |______|     ║ "Keeping your system warm        ║
     /|\    /|\             ║     and running smoothly."       ║
    / | \  / | \            ║                                  ║
   /  |  \/  |  \           ║ Press any key to begin...        ║
  /___|_______|___\         ╚══════════════════════════════════╝
      | | | | |
      ^ ^ ^ ^ ^
'@

# Determine script directory
$scriptDirectory = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Path $MyInvocation.MyCommand.Path -Parent }

# Paths and Variables
$hearthDirectory = Join-Path -Path $env:LOCALAPPDATA -ChildPath 'Hearth'
$configDirectory = Join-Path -Path $hearthDirectory -ChildPath 'Config'
$configFile = Join-Path -Path $configDirectory -ChildPath 'HearthSettings.json'
$schemaFile = Join-Path -Path $configDirectory -ChildPath 'HearthSettings.schema.json'
$modulesDirectory = Join-Path -Path $scriptDirectory -ChildPath 'Modules'

# Function to initialize directories and configuration files
function Initialize-Hearth {
    try {
        # Create directories if they don't exist
        if (-not (Test-Path -Path $configDirectory -PathType Container)) {
            $null = New-Item -Path $configDirectory -ItemType Directory -Force
            Write-Output "Created directory: $configDirectory"
        }

        # Create initial configuration file if it doesn't exist
        if (-not (Test-Path -Path $configFile -PathType Leaf)) {
            $initialConfig = @{
                AutomatedUpdates = $true
                SystemMaintenance = $true
                UpdateChocolatey = $true
                InvokeSFCScan = $true
                OverrideUpdates = $false
                OverrideMaintenance = $false
            } | ConvertTo-Json -Depth 4

            $initialConfig | Set-Content -Path $configFile -Force
            Write-Output "Created initial configuration file: $configFile"
        }

        # Create schema file if it doesn't exist or doesn't match the expected schema
        $expectedSchema = @{
            "$schemaContent" = @{
                "type" = "object"
                "properties" = @{
                    "AutomatedUpdates" = @{
                        "type" = "boolean"
                    }
                    "SystemMaintenance" = @{
                        "type" = "boolean"
                    }
                    "UpdateChocolatey" = @{
                        "type" = "boolean"
                    }
                    "InvokeSFCScan" = @{
                        "type" = "boolean"
                    }
                    "OverrideUpdates" = @{
                        "type" = "boolean"
                    }
                    "OverrideMaintenance" = @{
                        "type" = "boolean"
                    }
                }
                "required" = @(
                    "AutomatedUpdates",
                    "SystemMaintenance",
                    "UpdateChocolatey",
                    "InvokeSFCScan",
                    "OverrideUpdates",
                    "OverrideMaintenance"
                )
                "additionalProperties" = $false
            }
        } | ConvertTo-Json -Depth 4

        $currentSchema = $null
        if (Test-Path -Path $schemaFile -PathType Leaf) {
            $currentSchema = Get-Content -Path $schemaFile -Raw | ConvertFrom-Json
        }

        if (-not $currentSchema -or ($currentSchema | ConvertTo-Json -Depth 4) -ne ($expectedSchema | ConvertTo-Json -Depth 4)) {
            $expectedSchema | Set-Content -Path $schemaFile -Force
            Write-Output "Created or updated schema file: $schemaFile"
        }

        Write-Output "Directories initialized successfully."
    }
    catch {
        Write-Error "Initialization failed: $_"
        exit 1
    }
}

# Function to load configuration and validate using JSON Schema
function Load-Configuration {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ConfigPath,

        [Parameter(Mandatory = $true)]
        [string]$SchemaPath
    )

    try {
        $config = Get-Content -Path $ConfigPath -Raw -ErrorAction Stop | ConvertFrom-Json
        $schema = Get-Content -Path $SchemaPath -Raw -ErrorAction Stop | ConvertFrom-Json

        if ($config -isnot [object]) {
            throw "Invalid configuration format. Expected JSON object."
        }

        # Perform validation against schema
        $isValid = $config.PSObject.Properties.Name -eq $schema.PSObject.Properties.Name
        if (-not $isValid) {
            throw "Configuration does not match the schema."
        }

        Write-Output "Configuration loaded and validated successfully."
        return $config
    }
    catch {
        Write-Error "Failed to load or validate configuration: $_"
        exit 1
    }
}

# Function to import Hearth modules
function Import-HearthModule {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ModuleName
    )

    try {
        if (Test-Path $ModuleName) {
            Import-Module $ModuleName -ErrorAction Stop
            Write-Output "Module imported successfully: $ModuleName"
        } else {
            throw "$ModuleName module not found. Please ensure it is installed."
        }
    }
    catch {
        Write-Error "Failed to import module: $_"
        exit 1
    }
}

# Function to execute Hearth tasks
function Execute-Hearth {
    try {
        # Perform automated updates if enabled
        if ($config.AutomatedUpdates) {
            Invoke-ChocolateyUpdate
            Invoke-ScoopUpdate
            Invoke-WingetUpdate
        }

        # Perform system maintenance if enabled
        if ($config.SystemMaintenance) {
            Invoke-SFCScan
            Invoke-DefenderScan
            Invoke-DiskCleanup
        }

        Write-Output "Hearth tasks executed successfully."
    }
    catch {
        Write-Error "Failed to execute Hearth tasks: $_"
        exit 1
    }
}

# Main script logic
try {
    Clear-Host
    Write-Output $logo
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Clear-Host

    Initialize-Hearth
    Write-Output "Hearth initialized successfully."

    # Load configuration and validate
    $config = Load-Configuration -ConfigPath $configFile -SchemaPath $schemaFile

    # Import Hearth modules
    $Modules = @(
        "$modulesDirectory\HearthInstaller\HearthInstaller.psm1",
        "$modulesDirectory\Invoke-ChocolateyUpdate\Invoke-ChocolateyUpdate.psm1",
        "$modulesDirectory\Invoke-ScoopUpdate\Invoke-ScoopUpdate.psm1",
        "$modulesDirectory\Invoke-WingetUpdate\Invoke-WingetUpdate.psm1",
        "$modulesDirectory\Invoke-SFCScan\Invoke-SFCScan.psm1",
        "$modulesDirectory\Invoke-DefenderScan\Invoke-DefenderScan.psm1",
        "$modulesDirectory\Invoke-DiskCleanup\Invoke-DiskCleanup.psm1"
    )

    $Modules | ForEach-Object {
        Import-HearthModule -ModuleName $_
    }

    # Execute Hearth tasks
    Execute-Hearth
}
catch {
    Write-Error "An unexpected error occurred: $_"
    exit 1
}

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

# ASCII Art and Initialize-Hearth Function
$logo = @'
    /\                      ╔══════════════════════════════════╗
   /  \                     ║        Welcome to Hearth         ║
  /____\                    ║ -------------------------------- ║
 /|    |\     _____         ║ Automated System Maintenance     ║
/_|____| \   (     )        ║        for Windows               ║
  |    |     \   /          ║                                  ║
  |  []|      \ /           ║ Version: 1.0                     ║
  |____|_______V______      ║ Author: Liam Weise               ║
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

# Paths and Constants
$hearthDirectory = "$env:LOCALAPPDATA\Hearth"
$configDirectory = "$hearthDirectory\Config"
$configFile = "$configDirectory\HearthSettings.json"
$schemaFile = "$configDirectory\HearthSettings.schema.json"

# Function to initialize directories and configuration files
function Initialize-Hearth {
    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'

    try {
        # Create directories if they don't exist
        if (-not (Test-Path -Path $configDirectory -PathType Container)) {
            New-Item -Path $configDirectory -ItemType Directory -Force | Out-Null
            Write-Output "Directories initialized successfully."
        }

        # Create initial configuration file if it doesn't exist
        if (-not (Test-Path -Path $configFile -PathType Leaf)) {
            # Create initial configuration JSON content
            $initialConfig = @{
                AutomatedUpdates = $true
                SystemMaintenance = $true
                UpdateChocolatey = $true
                InvokeSFCScan = $true
                OverrideUpdates = $false
                OverrideMaintenance = $false
            } | ConvertTo-Json -Depth 4

            $initialConfig | Set-Content -Path $configFile -Force
            Write-Output "Initial configuration file created."
        }

        # Create schema file if it doesn't exist
        if (-not (Test-Path -Path $schemaFile -PathType Leaf)) {
            # Example schema content (adjust as per your actual schema requirements)
            $initialSchema = @{
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

            $initialSchema | Set-Content -Path $schemaFile -Force
            Write-Output "Schema file created."
        }

        Write-Output "Hearth initialized successfully."
    }
    catch {
        Write-Error "Initialization failed: $_"
        exit 1
    }
}

# Initialize Hearth if not already installed
if (-not (Test-Path -Path $configFile -PathType Leaf)) {
    Initialize-Hearth
    Write-Output "Hearth has been installed successfully."
}

# Function to load configuration and validate using JSON Schema
function Load-Configuration {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ConfigPath,

        [Parameter(Mandatory = $true)]
        [string]$SchemaPath
    )

    $config = $null
    $schema = $null

    try {
        $config = Get-Content -Path $ConfigPath -Raw -ErrorAction Stop | ConvertFrom-Json
        $schema = Get-Content -Path $SchemaPath -Raw -ErrorAction Stop | ConvertFrom-Json
    }
    catch {
        Write-Error "Failed to load configuration or schema file: $_"
        exit 1
    }

    if ($config -isnot [object]) {
        Write-Error "Invalid configuration format. Expected JSON object."
        exit 1
    }

    # Perform validation against schema
    $isValid = $config.PSObject.Properties.Name -eq $schema.PSObject.Properties.Name
    if (-not $isValid) {
        Write-Error "Configuration does not match the schema."
        exit 1
    }

    return $config
}

# Load configuration and validate
$config = Load-Configuration -ConfigPath $configFile -SchemaPath $schemaFile

# Function to import Hearth modules
function Import-HearthModule {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ModuleName
    )

    if (Test-Path $ModuleName) {
        try {
            Import-Module $ModuleName -ErrorAction Stop
            Write-Output "Module imported: $($ModuleName | Split-Path -Leaf)"
        }
        catch {
            Write-Error "Failed to import module: $ModuleName"
            exit 1
        }
    }
    else {
        Write-Error "$ModuleName module not found. Please ensure it is installed."
        exit 1
    }
}

# Paths to Hearth modules
$modulesPath = "$PSScriptRoot\Modules"

# List of modules to import
$modules = @(
    "$modulesPath\HearthInstaller\HearthInstaller.psm1",
    "$modulesPath\Invoke-ChocolateyUpdate\Invoke-ChocolateyUpdate.psm1",
    "$modulesPath\Invoke-ScoopUpdate\Invoke-ScoopUpdate.psm1",
    "$modulesPath\Invoke-WingetUpdate\Invoke-WingetUpdate.psm1",
    "$modulesPath\Invoke-SFCScan\Invoke-SFCScan.psm1",
    "$modulesPath\Invoke-DefenderScan\Invoke-DefenderScan.psm1",
    "$modulesPath\Invoke-DiskCleanup\Invoke-DiskCleanup.psm1"
)

# Import Hearth modules
$modules | ForEach-Object {
    Import-HearthModule -ModuleName $_
}

# Function to perform maintenance tasks
function Start-HearthMaintenance {
    Write-Output "Performing maintenance tasks..."

    # Example: Perform automated updates if enabled in configuration
    if ($config.AutomatedUpdates) {
        Invoke-ChocolateyUpdate
        Invoke-ScoopUpdate
        Invoke-WingetUpdate
    }

    # Example: Perform system maintenance if enabled in configuration
    if ($config.SystemMaintenance) {
        Invoke-SFCScan
        Invoke-DefenderScan
        Invoke-DiskCleanup
    }

    Write-Output "Maintenance tasks completed."
}

# Entry point
Clear-Host
Write-Output $logo
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host

# Check if installation is needed and perform initial setup
if (-not (Test-Path -Path $configFile -PathType Leaf)) {
    Initialize-Hearth
    Write-Output "Hearth has been installed successfully."
}
else {
    Write-Output "Hearth is already installed."
}

# Call main function to perform maintenance tasks
Start-HearthMaintenance

# ASCII Art and Initialize-Hearth Function
$logo = @'
    /\                      ╔══════════════════════════════════╗
   /  \                     ║        Welcome to Hearth         ║
  /____\                    ║ -------------------------------- ║
 /|    |\     _____         ║ Automated System Maintenance     ║
/_|____| \   (     )        ║        for Windows               ║
  |    |     \   /          ║                                  ║
  |  []|      \ /           ║ Version: 1.0                     ║
  |____|_______V______      ║ Author: Kaleb Weise              ║
  |    |  _    |      |     ║         A *Mute Observer         ║
  |    | (_)   |  []  |     ║                                  ║
  |____|______ |______|     ║ "Keeping your system warm        ║
     /|\    /|\             ║     and well-kindled."           ║
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

# Function to perform maintenance tasks
function Start-HearthMaintenance {
    Write-Output "Performing maintenance tasks..."
    # Example maintenance tasks can go here
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

# Call main functions or tasks here
Start-HearthMaintenance

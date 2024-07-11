# Hearth 🏠 ![Version](https://img.shields.io/badge/version-1.0.0-blue.svg?style=flat-square) ![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat-square)

Hearth is a powerful PowerShell-based system maintenance utility designed for Windows environments. It automates package updates, system maintenance tasks, and provides flexible configuration options to suit different user needs.

## 🌟 Features

- **Automated Package Updates**: Keep your system up-to-date with Chocolatey, Scoop, and Winget package managers.
- **System Maintenance**: Perform essential tasks like SFC scan, Windows Defender scan, and disk cleanup.
- **Flexible Configuration**: Easily customize tasks and their execution behavior through a JSON-based configuration file.
- **Command-Line Control**: Manage tasks using command-line options for enhanced flexibility.
- **Dry Run Mode**: Preview actions without making actual changes to your system.
- **Secure and Efficient**: Requires administrator privileges for sensitive operations.

## 🚀 Installation

To install Hearth, execute the following PowerShell command (requires administrative privileges):

```powershell
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/MuteObserver/Hearth/main/Hearth.ps1'))
```

This script will set up Hearth in `%LOCALAPPDATA%\Hearth` and configure it for immediate use.

## 💻 Usage

Once installed, you can run Hearth by typing the following command in PowerShell:

```powershell
hearth
```

### 🚩 Command-Line Options

- **-ResetConfig**: Resets the configuration to default settings.
- **-IgnoreNever**: Forces tasks to run even if set to "never" in the config.
- **-ForceAll**: Executes all tasks without prompting.
- **-DryRun**: Simulates task execution without applying changes.
- **-Uninstall**: Removes Hearth configuration and aliases.

**Examples:**

```powershell
hearth -ResetConfig
hearth -IgnoreNever -ForceAll
hearth -DryRun
hearth -Uninstall
```

## ⚙️ Configuration

Hearth's behavior is controlled via `%USERPROFILE%\.hearth_config.json`, allowing you to adjust each task's execution behavior:

```json
{
  "AutomatedUpdates": "ask",
  "SystemMaintenance": "ask",
  "ChocolateyUpdate": "ask",
  "ScoopUpdate": "ask",
  "WingetUpdate": "ask",
  "SFCScan": "ask",
  "DefenderScan": "ask",
  "DiskCleanup": "ask"
}
```

Options for each task: "always", "never", "ask" (default).

## 🛠️ Architecture

- **PowerShell Core**: Leveraging native Windows scripting for efficiency.
- **Modular Design**: Each task (update, scan, cleanup) is handled by separate functions.
- **JSON Configuration**: Clear and straightforward configuration management.
- **Command-Line Interface**: Enhances usability with flexible command options.
- **Secure Execution**: Ensures safety with mandatory administrator privileges.

## 🆕 New Features

- **Smart Execution**: Detects and installs missing package managers automatically.
- **Self-Upgrading**: Keeps itself and all components up-to-date for optimal performance.
- **Smart Task Management**: Adapts to system configurations for efficient operation.

## 🗑️ Uninstallation

To remove Hearth completely from your system, use the following command:

```powershell
hearth -Uninstall
```

This command will delete Hearth's configuration and aliases from your PowerShell profile.

## 👨‍💻 Author

Hearth is developed and maintained by [Kaleb Weise](https://twitter.com/A_Mute_Observer). Connect with me on [GitHub](https://github.com/MuteObserver) for feedback and contributions.

## 🤝 Contributing

We welcome contributions and feedback! If you encounter issues or have suggestions for improvements, please do inform me. When contributing, please adhere to PowerShell best practices and include relevant tests and documentation updates.

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 🙏 Acknowledgements

- [PSWindowsUpdate](https://github.com/microsoft/PSWindowsUpdate)
- [Chocolatey](https://chocolatey.org/)
- [Scoop](https://scoop.sh/)
- [Windows Package Manager (winget)](https://github.com/microsoft/winget-cli)

---

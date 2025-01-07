# version-check.ps1
# This script checks versions of development tools and generates a report

# Function to safely check version of a command
function Get-SafeVersion {
    param (
        [string]$Command,
        [string]$Arguments
    )
    
    try {
        $version = Invoke-Expression "$Command $Arguments"
        return $version
    }
    catch {
        return "Not installed or not found in PATH"
    }
}

# Create timestamp for the report
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Initialize the report content with Markdown
$report = @"
# Development Environment Status Report
Generated on: $timestamp

## System Information
Operating System: $(Get-CimInstance Win32_OperatingSystem | Select-Object Caption).Caption
PowerShell Version: $($PSVersionTable.PSVersion)

## Development Tools Versions

### Node.js Environment
- Node.js: $(Get-SafeVersion "node" "-v")
- npm: $(Get-SafeVersion "npm" "-v")
- yarn: $(Get-SafeVersion "yarn" "-v")
- pnpm: $(Get-SafeVersion "pnpm" "-v")

### Python Environment
- Python: $(Get-SafeVersion "python" "--version 2>&1")
- pip: $(Get-SafeVersion "pip" "--version")

### Version Control
- Git: $(Get-SafeVersion "git" "--version")

### Package Managers
- Chocolatey: $(Get-SafeVersion "choco" "--version")
- Scoop: $(Get-SafeVersion "scoop" "--version")

### Additional Tools
- Docker: $(Get-SafeVersion "docker" "--version")
- Docker Compose: $(Get-SafeVersion "docker-compose" "--version")

## VS Code Extensions
"@

# Get VS Code extensions
$extensions = code --list-extensions
foreach ($extension in $extensions) {
    $report += "`n- $extension"
}

# Save the report
$reportPath = Join-Path $env:USERPROFILE "\code\vscode\dev-environment-status.md"
$report | Out-File -FilePath $reportPath -Encoding UTF8

# Open the file in VS Code
Start-Process "code" -ArgumentList "-r `"$reportPath`""

# Return the path
return $reportPath
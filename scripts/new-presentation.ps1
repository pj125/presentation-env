# Create a new Slidev presentation from the template (Windows / PowerShell).
# Usage: .\scripts\new-presentation.ps1 <name>
param(
    [Parameter(Mandatory = $true)]
    [string]$Name
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($Name) -or $Name -match '[\\/]' -or $Name.StartsWith('.')) {
    Write-Error "Name must not be empty, contain '/' or '\', or start with '.'"
    exit 1
}

$root = Split-Path -Parent $PSScriptRoot
$target = Join-Path (Join-Path $root 'presentations') $Name

if (Test-Path $target) {
    Write-Error "Presentation '$Name' already exists at $target"
    exit 1
}

New-Item -ItemType Directory -Path $target | Out-Null
$template = Get-Content -Raw -Path (Join-Path (Join-Path $root 'templates') 'slides.md')
$content = $template.Replace('New Presentation', $Name)
[System.IO.File]::WriteAllText((Join-Path $target 'slides.md'), $content)

Write-Host "Created $(Join-Path $target 'slides.md')"
Write-Host "Start it with: `$env:PRESENTATION='$Name'; podman compose up"

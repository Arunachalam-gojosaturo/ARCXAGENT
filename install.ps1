# ==============================================================================
#  ⚡ ARC X AGENT - One-Line Windows PowerShell Installer
#  Usage: irm https://raw.githubusercontent.com/Arunachalam-gojosaturo/ARCXAGENT/main/install.ps1 | iex
# ==============================================================================
param(
    [string]$RepoUrl = "https://github.com/Arunachalam-gojosaturo/ARCXAGENT.git",
    [string]$Branch = "main",
    [string]$InstallDir = "$env:LOCALAPPDATA\arc-x\arc-x-agent"
)

Write-Host "⚡ ARC X AGENT - Windows Installer" -ForegroundColor Cyan
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is required. Please install Git from https://git-scm.com and re-run."
    exit 1
}

if (Test-Path $InstallDir) {
    Write-Host "Updating existing installation at $InstallDir..." -ForegroundColor Yellow
    git -C $InstallDir fetch --depth=1 origin $Branch
    git -C $InstallDir checkout -f $Branch
    git -C $InstallDir reset --hard "origin/$Branch"
} else {
    Write-Host "Cloning $RepoUrl..." -ForegroundColor Green
    New-Item -ItemType Directory -Path (Split-Path $InstallDir) -Force | Out-Null
    git clone --depth=1 --branch $Branch $RepoUrl $InstallDir
}

Set-Location $InstallDir
Write-Host "✨ ARC X AGENT INSTALLATION COMPLETE!" -ForegroundColor Green
Write-Host "Run: arc-x"

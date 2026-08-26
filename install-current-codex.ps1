[CmdletBinding()]
param(
  [string]$SourcePath,
  [string]$DestinationRoot
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($SourcePath)) {
  $SourcePath = $PSScriptRoot
}
if ([string]::IsNullOrWhiteSpace($DestinationRoot)) {
  $DestinationRoot = Join-Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)) '.codex\skills'
}
$source = (Resolve-Path -LiteralPath $SourcePath).Path
if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md'))) {
  throw 'SourcePath must contain SKILL.md.'
}

$skillName = Split-Path -Leaf $source
$destination = Join-Path $DestinationRoot $skillName
$staging = Join-Path $DestinationRoot (".$skillName-staging-" + [guid]::NewGuid())
$backup = Join-Path $DestinationRoot ("$skillName-backup-" + (Get-Date -Format 'yyyyMMdd-HHmmss'))
$excluded = @('tests', '.git', 'install-current-codex.ps1', '安装到本机.cmd')

New-Item -ItemType Directory -Force -Path $DestinationRoot | Out-Null
New-Item -ItemType Directory -Force -Path $staging | Out-Null

try {
  Get-ChildItem -LiteralPath $source -Force |
    Where-Object { $_.Name -notin $excluded } |
    Copy-Item -Destination $staging -Recurse -Force

  if (Test-Path -LiteralPath $destination) {
    Move-Item -LiteralPath $destination -Destination $backup
  }
  Move-Item -LiteralPath $staging -Destination $destination
  Write-Output "Installed $skillName to $destination"
  if (Test-Path -LiteralPath $backup) {
    Write-Output "Previous local copy kept at $backup"
  }
}
catch {
  if (-not (Test-Path -LiteralPath $destination) -and (Test-Path -LiteralPath $backup)) {
    Move-Item -LiteralPath $backup -Destination $destination
  }
  throw
}
finally {
  if (Test-Path -LiteralPath $staging) {
    Remove-Item -LiteralPath $staging -Recurse -Force
  }
}

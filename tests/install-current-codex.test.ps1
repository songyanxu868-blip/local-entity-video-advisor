$ErrorActionPreference = 'Stop'

$skillRoot = Split-Path -Parent $PSScriptRoot
$installer = Join-Path $skillRoot 'install-current-codex.ps1'
if (-not (Test-Path -LiteralPath $installer)) {
  throw 'Expected a portable installer at install-current-codex.ps1.'
}

$testRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("local-entity-skill-test-" + [guid]::NewGuid())
try {
  $sourceRoot = Join-Path $testRoot 'local-entity-video-advisor'
  $destinationRoot = Join-Path $testRoot 'destination'
  New-Item -ItemType Directory -Force -Path $sourceRoot | Out-Null
  Set-Content -LiteralPath (Join-Path $sourceRoot 'SKILL.md') -Encoding UTF8 -Value "---`nname: local-entity-video-advisor`ndescription: test`n---"
  New-Item -ItemType Directory -Force -Path (Join-Path $sourceRoot 'references') | Out-Null
  Set-Content -LiteralPath (Join-Path $sourceRoot 'references\content-framework.md') -Encoding UTF8 -Value 'test reference'

  & $installer -SourcePath $sourceRoot -DestinationRoot $destinationRoot

  $installedRoot = Join-Path $destinationRoot 'local-entity-video-advisor'
  if (-not (Test-Path -LiteralPath (Join-Path $installedRoot 'SKILL.md'))) {
    throw 'Installer did not create the installed SKILL.md.'
  }
  if (-not (Test-Path -LiteralPath (Join-Path $installedRoot 'references\content-framework.md'))) {
    throw 'Installer did not copy the reference file.'
  }
  if (Test-Path -LiteralPath (Join-Path $installedRoot 'tests')) {
    throw 'Installer copied test-only files into the runnable skill.'
  }

  $defaultDestinationRoot = Join-Path $testRoot 'default-destination'
  & powershell -NoProfile -ExecutionPolicy Bypass -File $installer -DestinationRoot $defaultDestinationRoot
  $defaultInstalledRoot = Join-Path $defaultDestinationRoot 'local-entity-video-advisor'
  if (-not (Test-Path -LiteralPath (Join-Path $defaultInstalledRoot 'SKILL.md'))) {
    throw 'Installer did not resolve its own source folder by default.'
  }

  Write-Output 'PASS: portable installer creates a runnable skill without test files.'
}
finally {
  if (Test-Path -LiteralPath $testRoot) {
    Remove-Item -LiteralPath $testRoot -Recurse -Force
  }
}

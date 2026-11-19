# Workspace-local Flutter entry point; falls back to an SDK already on PATH.
$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent $PSScriptRoot
$sdkCommand = Join-Path $taskRoot '.tools\flutter\bin\flutter.bat'
$env:PATH = "$env:SystemRoot\System32;$env:SystemRoot;$env:PATH"
if (-not (Test-Path -LiteralPath $sdkCommand)) {
    $sdkCommand = (Get-Command flutter -ErrorAction Stop).Source
}
& $sdkCommand @args
exit $LASTEXITCODE

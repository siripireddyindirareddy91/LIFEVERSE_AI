param([string]$ConfigPath = '')
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$signingDirectory = Join-Path $repo '.tools\android-signing'
New-Item -ItemType Directory -Force $signingDirectory | Out-Null
$keystore = Join-Path $signingDirectory 'lifeverse-upload.p12'
$protectedPassword = Join-Path $signingDirectory 'store-password.dpapi'
if (!(Test-Path -LiteralPath $protectedPassword)) {
    if (Test-Path -LiteralPath $keystore) { throw 'Signing password backup is missing. Restore it before rebuilding.' }
    $password = [Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
    ConvertTo-SecureString $password -AsPlainText -Force | ConvertFrom-SecureString | Set-Content -LiteralPath $protectedPassword
} else {
    $securePassword = Get-Content -LiteralPath $protectedPassword | ConvertTo-SecureString
    $password = [System.Net.NetworkCredential]::new('', $securePassword).Password
}
if (!$env:JAVA_HOME) { $env:JAVA_HOME = 'C:\Program Files\Android\Android Studio\jbr' }
$keytool = Join-Path $env:JAVA_HOME 'bin\keytool.exe'
$env:LIFEVERSE_KEYSTORE_PATH = $keystore
$env:LIFEVERSE_STORE_PASSWORD = $password
$env:LIFEVERSE_KEY_PASSWORD = $password
$env:LIFEVERSE_KEY_ALIAS = 'lifeverse-upload'
$flutter = Join-Path $repo '.tools\flutter\bin\flutter.bat'
try {
    if (!(Test-Path -LiteralPath $keystore)) {
        & $keytool -genkeypair -noprompt -keystore $keystore -storetype PKCS12 -alias lifeverse-upload -keyalg RSA -keysize 3072 -validity 10000 -dname 'CN=LIFEVERSE AI' -storepass:env LIFEVERSE_STORE_PASSWORD -keypass:env LIFEVERSE_KEY_PASSWORD
        if ($LASTEXITCODE -ne 0) { throw 'Signing key generation failed' }
    }
    Push-Location (Join-Path $repo 'mobile')
    try {
        $buildArguments = @('build','apk','--release','--target-platform','android-arm64','--build-name','0.1.1','--build-number','2','--no-pub')
        if ($ConfigPath) { $buildArguments += "--dart-define-from-file=$ConfigPath" }
        else { $buildArguments += '--dart-define=APP_ENV=development' }
        & $flutter @buildArguments
        if ($LASTEXITCODE -ne 0) { throw 'Signed APK build failed' }
    } finally { Pop-Location }
    $output = Join-Path $repo '.tools\phone-preview\LIFEVERSE_AI-signed-preview-arm64.apk'
    New-Item -ItemType Directory -Force (Split-Path $output -Parent) | Out-Null
    Copy-Item -LiteralPath (Join-Path $repo 'mobile\build\app\outputs\flutter-apk\app-release.apk') -Destination $output
    Write-Output "Signed preview saved: $output"
    Write-Output 'Signing key and Windows-user-protected password are in .tools/android-signing. Back these up securely; never commit them.'
} finally {
    Remove-Item Env:LIFEVERSE_KEYSTORE_PATH, Env:LIFEVERSE_STORE_PASSWORD, Env:LIFEVERSE_KEY_PASSWORD, Env:LIFEVERSE_KEY_ALIAS -ErrorAction SilentlyContinue
    $password = $null
}

param(
    [Parameter(Mandatory=$true)]
    [string]$HomeDir
)

# Check that HomeDir is not empty and is a valid directory
if (-not (Test-Path -Path $HomeDir -PathType Container)) {
    Write-Error "Error: '$HomeDir' is not a valid directory"
    exit 1
}

# Ensure .ssh directory exists
$SshDir = Join-Path $HomeDir ".ssh"
if (-not (Test-Path -Path $SshDir -PathType Container)) {
    New-Item -ItemType Directory -Path $SshDir -Force | Out-Null
}

# Fetch the age private key using the Bitwarden CLI
$item = bw get item "ChezMoi Dotfiles Manager" | ConvertFrom-Json
$field = $item.fields | Where-Object { $_.name -eq "age_private_key" }

if (-not $field) {
    Write-Error "Error: Could not find 'age_private_key' field in Bitwarden item"
    exit 1
}

$keyPath = Join-Path $SshDir ".age_private_key.txt"
$field.value | Set-Content -Path $keyPath -NoNewline -Encoding UTF8

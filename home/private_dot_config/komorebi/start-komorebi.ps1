$env:KOMOREBI_CONFIG_HOME = "C:\Users\witloxkhd\.config\komorebi"

# Stop existing instances if running
if (Get-Process -Name komorebi -ErrorAction SilentlyContinue) {
    Write-Host "Stopping existing komorebi..." -ForegroundColor Yellow
    komorebic stop --whkd --bar 2>&1 | Out-Null
    Start-Sleep -Seconds 2
}

Write-Host "Starting komorebi..." -ForegroundColor Cyan
try {
    komorebic start --whkd --bar 2>&1 | ForEach-Object {
        Write-Host $_
    }
    if ($LASTEXITCODE -ne 0) { throw "komorebic exited with code $LASTEXITCODE" }
    Write-Host "`nKomorebi started successfully." -ForegroundColor Green
    Start-Sleep -Seconds 2
    exit 0
} catch {
    Write-Host "`nError starting komorebi:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "`nPress any key to close..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

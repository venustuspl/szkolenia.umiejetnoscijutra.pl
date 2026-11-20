#!/bin/bash

echo "=== Status lokalnego stosu AI ==="
echo ""

# 1. Sprawdzenie Ollamy (systemd)
if systemctl is-active --quiet ollama; then
    echo -e "🟢 Ollama:       [ AKTYWNA ] (systemd)"
else
    echo -e "🔴 Ollama:       [ WYŁĄCZONA ]"
fi

# 2. Sprawdzenie Open WebUI (proces w tle)
if pgrep -f "open-webui" > /dev/null; then
    echo -e "🟢 Open WebUI:   [ AKTYWNY ] (port 3000)"
else
    echo -e "🔴 Open WebUI:   [ WYŁĄCZONY ]"
fi

# 3. Sprawdzenie n8n (PM2)
if pm2 info n8n 2>/dev/null | grep -q "online"; then
    echo -e "🟢 n8n:          [ AKTYWNY ] (PM2 - port 5678)"
else
    echo -e "🔴 n8n:          [ WYŁĄCZONY ]"
fi

echo ""
echo "=== Koniec sprawdzenia ==="

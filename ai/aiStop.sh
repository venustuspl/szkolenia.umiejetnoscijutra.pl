#!/bin/bash

echo "=== Zatrzymywanie lokalnego stosu AI ==="

# 1. Zatrzymanie Ollamy (systemd)
echo "[1/3] Zatrzymywanie usługi Ollama..."
sudo systemctl stop ollama
if [ $? -eq 0 ]; then
    echo "Ollama została zatrzymana."
else
    echo "Nie udało się zatrzymać Ollamy (lub nie była uruchomiona)."
fi

# 2. Zatrzymanie Open WebUI (zabicie procesu uvx / open-webui)
echo "[2/3] Zatrzymywanie Open WebUI..."
pkill -f "open-webui"
if [ $? -eq 0 ]; then
    echo "Open WebUI został zatrzymany."
else
    echo "Open WebUI nie był aktywny w tle."
fi

# 3. Zatrzymanie n8n (przez PM2)
echo "[3/3] Zatrzymywanie n8n..."
pm2 stop n8n > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "n8n został zatrzymany."
else
    echo "n8n nie był aktywny w PM2."
fi

